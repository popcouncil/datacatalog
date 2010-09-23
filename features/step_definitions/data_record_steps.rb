Given /^a data record titled "(.*)" exists$/ do |title|
  Given %Q(an organization named "Red Cross" exists)

  the.data_record = DataRecord.make(
    :title        => title,
    :organization => the.organization
  ) do |data_record|
    data_record.documents << Document.make
  end
end

Given /^the following data records exist:$/ do |table|
  table.hashes.each do |attr|
    if attr["organization"].present?
      attr["organization"] = Organization.find_by_name(attr["organization"]) || Organization.make(:name => attr["organization"])
    end

    if (ministry_name = attr.delete("ministry")) && ministry_name.present?
      attr["owner"] = User.ministry_users.find_by_display_name(ministry_name) || User.make(:display_name => ministry_name, :role => "ministry_user")
    end

    DataRecord.make(attr)
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

Then /^I should only see (\d+) records?$/ do |count|
  page.should have_css("#browseTable tbody tr", :count => count.to_i)
end

Then /^I should see ministry records before community records$/ do
  ministry_records, community_records = DataRecord.ministry_records_first.partition do |data_record|
    data_record.ministry
  end

  page.should have_css("#data_record_#{ministry_records.last.id} + #data_record_#{community_records.first.id}")
end
