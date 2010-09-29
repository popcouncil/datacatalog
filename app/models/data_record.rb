class DataRecord < ActiveRecord::Base
  belongs_to :owner,        :class_name => "User"
  belongs_to :author,       :dependent => :destroy
  belongs_to :contact,      :dependent => :destroy
  belongs_to :catalog,      :dependent => :destroy
  belongs_to :location

  has_many :sponsors, :dependent => :destroy
  has_many :organizations, :through => :sponsors
  has_one  :lead_organization, :through => :sponsors,
                               :source  => :organization,
                               :conditions => { "sponsors.lead" => true }
  has_many :collaborators, :through => :sponsors,
                           :source  => :organization,
                           :conditions => { "sponsors.lead" => false }

  has_one :wiki, :dependent => :destroy

  has_many :documents, :dependent => :destroy
  has_many :favorites, :dependent => :destroy
  has_many :ratings,   :dependent => :destroy
  has_many :notes,     :dependent => :destroy

  before_validation_on_create :make_slug
  after_save :link_organizations

  validates_presence_of :location
  validates_presence_of :description
  validates_presence_of :lead_organization_name
  validates_presence_of :tag_list, :message => "can't be empty"
  validates_presence_of :slug, :if => :has_title?
  validates_presence_of :title
  validates_presence_of :year
  validates_presence_of :owner_id

  named_scope :ministry_records_first, :joins => :owner, :order => "users.role = 'ministry_user' DESC, created_at DESC"

  named_scope :by_location, lambda {|country|
    { :conditions => { :location_id => country } }
  }

  named_scope :by_ministry, lambda {|ministry|
    { :conditions => { :owner_id => ministry } }
  }

  named_scope :by_organization, lambda {|organization|
    { :joins => :organizations, :conditions => { "organizations.id" => organization } }
  }

  named_scope :by_release_year, lambda {|year|
    { :conditions => { :year => year } }
  }

  named_scope :by_tags, lambda {|*tags|
    { :joins => :tags, :conditions => { "tags.name" => tags }}
  }

  accepts_nested_attributes_for :author
  accepts_nested_attributes_for :contact
  accepts_nested_attributes_for :catalog
  accepts_nested_attributes_for :documents

  acts_as_taggable
  acts_as_commentable

  def self.available_years
    all(:select => "DISTINCT(year)", :order => "year DESC").map(&:year)
  end

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
    return nil if ratings_count.zero?
    (ratings.sum(:value) / ratings_count).round
  end

  def ratings_count
    ratings.count
  end

  private

  def make_slug
    self.slug = Slugs.make(self, title)
  end

  def has_title?
    title.present?
  end

  def link_organizations
    if lead_organization_name.present?
      lead = Organization.find_or_create_by_name(lead_organization_name)
      sponsors.create(:organization => lead, :lead => true)
    end

    if collaborator_list.present?
      collaborator_list.split(/\s*,\s*/).map(&:strip).each do |collab_name|
        collab = Organization.find_or_create_by_name(collab_name)
        sponsors.find_or_create_by_organization_id(:lead => false, :organization_id => collab.id)
      end
    end
  end
end
