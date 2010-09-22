class DataRecord < ActiveRecord::Base
  belongs_to :owner,        :class_name => "User"
  belongs_to :author,       :dependent => :destroy
  belongs_to :contact,      :dependent => :destroy
  belongs_to :catalog,      :dependent => :destroy
  belongs_to :organization

  has_one :wiki, :dependent => :destroy

  has_many :documents, :dependent => :destroy
  has_many :favorites, :dependent => :destroy
  has_many :ratings,   :dependent => :destroy
  has_many :notes,     :dependent => :destroy

  before_validation_on_create :make_slug

  validates_presence_of :country
  validates_presence_of :description
  validates_presence_of :slug, :if => :has_title?
  validates_presence_of :title
  validates_presence_of :year
  validates_presence_of :owner_id
  validates_inclusion_of :status, :in => %w(Planned Published Completed)

  named_scope :ministry_records_first, :joins => :owner, :order => "users.role = 'ministry_user' DESC, created_at DESC"

  accepts_nested_attributes_for :author
  accepts_nested_attributes_for :contact
  accepts_nested_attributes_for :catalog
  accepts_nested_attributes_for :documents

  acts_as_taggable
  acts_as_commentable

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
end
