class Organization < ActiveRecord::Base
  ORGANIZATION_TYPES = %w(Commercial Governmental Not-For-Profit)

  has_many :data_records, :dependent => :destroy

  validates_presence_of :name
  validates_presence_of :country
  validates_inclusion_of :org_type, :in => ORGANIZATION_TYPES
  validates_format_of :slug,
    :with        => /\A[a-zA-z0-9\-]+\z/,
    :message     => "can only contain alphanumeric characters and dashes",
    :allow_blank => true

  before_validation_on_create :make_slug

  acts_as_nested_set

  def to_param
    slug
  end

  private

  def make_slug
    self.slug = Slugs.make(self, name) if slug.blank?
  end
end
