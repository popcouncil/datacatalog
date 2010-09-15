class DataRecord < ActiveRecord::Base
  belongs_to :owner,   :class_name => "User"
  belongs_to :author,  :dependent => :destroy
  belongs_to :contact, :dependent => :destroy
  belongs_to :catalog, :dependent => :destroy

  before_validation_on_create :make_slug

  validates_presence_of :country
  validates_presence_of :description
  validates_presence_of :homepage_url
  validates_presence_of :slug
  validates_presence_of :title
  validates_presence_of :year
  validates_inclusion_of :status, :in => %w(Planned Published Completed)

  validates_presence_of :organization_id

  accepts_nested_attributes_for :author
  accepts_nested_attributes_for :contact
  accepts_nested_attributes_for :catalog

  acts_as_taggable

  def to_param
    slug
  end

  def organization
    @organization ||= DataCatalog::Organization.first(:id => organization_id)
  end

  def downloads
    []
  end

  def comments
    @comments ||= DataCatalog::Comment.all(:source_id => id)
  end

  private

  def make_slug
    slug_prefix = title.to_s.parameterize
    slug, n = slug_prefix, 2

    loop do
      break unless self.class.find_by_slug(slug)
      slug, n = "#{slug_prefix}-#{n}"
    end

    self.slug = slug
  end
end
