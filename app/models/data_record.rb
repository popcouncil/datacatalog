class DataRecord < ActiveRecord::Base
  STEPS = %w[screen1 screen2]
  attr_writer :current_step

  belongs_to :owner,        :class_name => "User"
  belongs_to :contact,      :dependent => :destroy
  belongs_to :catalog,      :dependent => :destroy

  has_many :data_record_locations, :dependent => :destroy
  has_many :locations, :through => :data_record_locations

  has_many :sponsors, :dependent => :destroy
  has_many :organizations, :through => :sponsors
  has_one  :lead_organization, :through => :sponsors,
                               :source  => :organization,
                               :conditions => { "sponsors.lead" => true }
  has_many :collaborators, :through => :sponsors,
                           :source  => :organization,
                           :conditions => { "sponsors.lead" => false }

  has_many :authors, :dependent => :destroy

  has_one :wiki, :dependent => :destroy

  has_many :documents, :dependent => :destroy
  has_many :favorites, :dependent => :destroy
  has_many :ratings,   :dependent => :destroy
  has_many :notes,     :dependent => :destroy

  before_validation_on_create :make_slug
  after_save :link_organizations
  after_update :check_alert_notifications, :if => :last_step?

  # - validations -
  validate :at_least_one_location, :if => :first_step?
  validate :no_duplicate_locations
  validates_presence_of :description, :if => :first_step?
  validates_presence_of :lead_organization_name, :if => :last_step?
  validates_presence_of :tag_list, :message => "can't be empty", :if => :first_step?
  validates_presence_of :slug, :if => :has_title?
  validates_presence_of :title, :if => :first_step?
  validates_presence_of :year, :allow_blank => false, :if => :first_step?
  validates_presence_of :owner_id, :if => :first_step?

  default_scope :conditions => "completed = '1'"

  named_scope :sorted, lambda {|sort|
    { :include => [:organizations, :owner, :locations, :documents, :tags],
      :order   => ["users.role = 'ministry_user' DESC", sort.presence, "locations.lft DESC", "data_records.created_at DESC"].compact.join(", ") }
  } 

  named_scope :by_location, lambda {|country|
    target_country = Location.find(country)

    { :include => :locations,
      :conditions => [
        "data_record_locations.location_id = :id OR (locations.lft <= :lft AND locations.rgt >= :rgt)",
        { :id => target_country.id, :lft => target_country.lft, :rgt => target_country.rgt }
      ]
    }
  }

  named_scope :by_ministry, lambda {|ministry|
    { :conditions => { :owner_id => ministry } }
  }

  named_scope :by_organization, lambda {|organization|
    { :include => :organizations, :conditions => { "organizations.id" => organization } }
  }

  named_scope :by_release_year, lambda {|year|
    { :conditions => { :year => year } }
  }

  named_scope :by_tags, lambda {|*tags|
    { :include => :tags, :conditions => { "tags.name" => tags }}
  }
  
  named_scope :by_document_type, lambda {|document_type|
    { :include => :documents, :conditions => {"documents.document_type" => document_type} }
  }

  accepts_nested_attributes_for :authors, :allow_destroy => true, :reject_if => lambda {|author| author[:name].blank? }
  accepts_nested_attributes_for :contact
  accepts_nested_attributes_for :catalog
  accepts_nested_attributes_for :documents, :allow_destroy => true
  accepts_nested_attributes_for :data_record_locations, :allow_destroy => true

  acts_as_taggable
  acts_as_commentable

  def self.browse(filters, sort_string=nil)
    filters.apply(sorted(sort_string))
  end

  def self.available_years
    all(:select => "DISTINCT(year)", :order => "year DESC").map(&:year)
  end

  def self.unscoped_find(*args)
    self.with_exclusive_scope { find(*args) }
  end

  # multi-step form methods
  def current_step
    @current_step || STEPS.first
  end

  def first_step?
    self.current_step == STEPS.first
  end

  def last_step?
    self.current_step == STEPS.last
  end

  def next_step
    self.current_step = STEPS[STEPS.index(current_step)+1] unless last_step?
  end

  def previous_step
    self.current_step = STEPS[STEPS.index(current_step)-1] unless first_step?
  end
  # end multi-step form methods

  def lead_organization_name=(name)
    @lead_organization_name = name
  end

  def lead_organization_name
    if defined?(@lead_organization_name)
      @lead_organization_name
    else
      lead_organization.try(:name) || owner.try(:affiliation).try(:name)
    end
  end

  def collaborator_list=(comma_separated_list)
    @collaborator_list = comma_separated_list
  end

  def collaborator_list
    if defined?(@collaborator_list)
      @collaborator_list
    else
      collaborators.map(&:name).join(", ")
    end
  end

  def ministry
    return unless owner.ministry_user?
    owner
  end

  def to_param
    slug
  end

  def downloads
    warn "DataRecord#downloads is deprecated (called from #{caller.first})"
    []
  end

  def annotations_by(user)
    notes.all(:conditions => { :user_id => user.id })
  end

  def ratings_average
    (ratings_total / [1, ratings_count].max).round
  end

  def build_contact_from_owner
    build_contact(:name  => owner.try(:display_name),
                  :email => owner.try(:email),
                  :phone => (owner.try(:telephone_number) || 'Phone'))
  end


  def coverage_list
    @coverage_list ||= self.locations.collect(&:name)
  end
  
  private

  def check_alert_notifications
    alerts = Alert.all(:conditions => ['(tag_id IN (?) or tag_id IS NULL) AND (location_id IN (?) OR location_id IS NULL)', self.tags.collect(&:id), self.locations.collect(&:id)])
    alerts.dup.each do |a|
      alerts.delete(a) if alerts.count { |x| x.user_id == a.user_id } > 1
    end
    # The notification process could potentially take a long time to process.
    # We will want to offload this into a DelayedJob or Resque worker
    alerts.each { |alert|  alert.alert!(self) }
    true
  end

  def make_slug
    self.slug = Slugs.make(self, title)
  end

  def has_title?
    title.present?
  end

  def at_least_one_location
    errors.add_to_base("Must cover at least one region.") if data_record_locations.empty?
  end

  def no_duplicate_locations
    dupes = data_record_locations.group_by {|loc| loc.location_id }.any? {|_, list| list.size > 1 }
    errors.add_to_base("Geographical Coverage can't have duplicates") if dupes
  end

  def link_organizations
    if lead_organization_name.present?
      lead = Organization.find_or_create_by_name(lead_organization_name)
      sponsors.find_or_create_by_organization_id(:lead => true, :organization_id => lead.id)
    end

    if collaborator_list.present?
      collaborator_list.split(/\s*,\s*/).map(&:strip).each do |collab_name|
        collab = Organization.find_or_create_by_name(collab_name)
        sponsors.find_or_create_by_organization_id(:lead => false, :organization_id => collab.id)
      end
    end
  end
end
