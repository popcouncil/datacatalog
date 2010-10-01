class Author < Person
  belongs_to :data_record
  belongs_to :affiliation, :class_name => "Organization"

  before_save :link_organization

  def affiliation_name=(name)
    @affiliation_name = name
  end

  def affiliation_name
    if defined?(@affiliation_name)
      @affiliation_name
    else
      affiliation.try(:name)
    end
  end

  private

  def link_organization
    if affiliation_name.present?
      org = Organization.find_or_create_by_name(:name => affiliation_name)
      self.affiliation = org
    end
  end
end
