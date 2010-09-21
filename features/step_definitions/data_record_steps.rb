Given /^a data record titled "(.*)" exists$/ do |title|
  Given %Q(an organization named "Red Cross" exists)

  unless User.first
    Given %Q(an user named "Johnny Data Record Creator" with "johnny@datarecordcreationsinc.com" exists)
  end

  the.data_record = DataRecord.create(
    :title           => title,
    :description     => "Some Description",
    :country         => "Namibia",
    :homepage_url    => "http://namibia.com/data",
    :year            => "2008",
    :status          => "Published",
    :organization_id => the.organization.id,
    :owner_id        => (the.user || User.first).id
  ) do |data_record|
    data_record.documents << Document.new(:external_url => "http://namibia.com/data/document")
  end
end

Given /^I favorited the data record$/ do
  the.user.favorite_records << the.data_record
end

When /^I fill in the data record fields$/ do
  When %Q(I fill in "Title" with "Housing Code Enforcement")
  When %Q(I fill in "Description" with "Blah blah blah blah")
  When %Q(I select "Uruguay" from "Country")
  When %Q(I select "DCRA" from "Organization")
  When %Q(I fill in "Author Name" with "Pepe Perez")
  When %Q(I fill in "Author Affiliation" with "DCRA Member")
  When %Q(I fill in "Homepage URL" with "http://data.dc.gov/foo")
  When %Q(I select "Published" from "Status")
  When %Q(I fill in "Project Name" with "The Project")
  When %Q(I fill in "Funder" with "Uncle Sam")
  When %Q(I fill in "Year" with "2008")
  When %Q(I fill in "Tags" with "housing, code enforcement, something else")
  When %Q(I fill in "Name" with "John Doe")
  When %Q(I fill in "Phone" with "+1 (234) 567 8900")
  When %Q(I fill in "Email" with "john.doe@example.org")
end

Then /^I should see the favorited data record$/ do
  Then %Q(I should see "#{the.data_record.title}")
end

Then /^the data record should be created by a (.+)$/ do |role|
  # FIXME: This should be featured in the UI, not checked in the database
  DataRecord.last.owner.role.should == normalize_role(role)
end
