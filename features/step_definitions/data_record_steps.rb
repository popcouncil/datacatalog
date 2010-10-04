Given /^a data record titled "(.*)" exists$/ do |title|
  Given %Q(an organization named "Red Cross" exists)

  the.data_record = DataRecord.make(:title => title, :lead_organization_name => the.organization.name)
  the.data_record.documents << Document.make(:document_type => "Data")
end

Given /^the following data records exist:$/ do |table|
  table.hashes.each do |attr|
    if (ministry_name = attr.delete("ministry")) && ministry_name.present?
      attr["owner"] = User.ministry_users.find_by_display_name(ministry_name) || User.make(:display_name => ministry_name, :role => "ministry_user")
    end

    if (locations = attr.delete("locations").split(/\s*,\s*/)) && locations.present?
      attr["data_record_locations"] = locations.map {|loc| DataRecordLocation.new(:location_id => Location.find_by_name(loc).id) }
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
  When %Q(I select "Uruguay" from "Geographical Coverage")
  When %Q(I fill in "Lead Organization" with "Red Cross International")
  When %Q(I fill in "Other Institutional Collaborators" with "Doctors Without Borders, United Nations")
  When %Q(I fill in "Homepage URL" with "http://data.dc.gov/foo")
  When %Q(I fill in "Project Name" with "The Project")
  When %Q(I fill in "Funder" with "Uncle Sam")
  When %Q(I select "2008" from "Year")
  When %Q(I fill in "Tags" with "housing, code enforcement, something else")

  # contact
  When %Q(I fill in "Name" with "John Doe")
  When %Q(I fill in "Phone" with "+1 (234) 567 8900")
  When %Q(I fill in "Email" with "john.doe@example.org")

  # documents
  When %Q(I choose "Provide an URL to an external file")
  When %Q(I fill in "External URL" with "http://document.url/file.csv")
  When %Q(I select "Data" from "Type")
end

When /^I fill in the (\w+) author name with "([^\"]+)"$/ do |position, value|
  %Q(When I fill in the #{position.to_i + 1} "Author Name" with "#{value}")
end

Then /^I should see the favorited data record$/ do
  Then %Q(I should see "#{the.data_record.title}")
end

Then /^the data record should be created by a (.+)$/ do |role|
  # FIXME: This should be featured in the UI, not checked in the database
  DataRecord.last.owner.role.should == normalize_role(role)
end

Then /^I should(?: only)? see (\d+) records?$/ do |count|
  page.should have_css("#browseTable tbody tr", :count => count.to_i)
end

Then /^I should see ministry records before community records$/ do
  ministry_records, community_records = DataRecord.ministry_records_first.partition do |data_record|
    data_record.ministry
  end

  page.should have_css("#data_record_#{ministry_records.last.id} + #data_record_#{community_records.first.id}")
end

Then /^I should see a record tagged "(.*)"$/ do |tag|
  within :css, "tr.data_record .tags" do
    Then %Q(I should see "#{tag}")
  end
end

Then /^the data record's lead organization should be "(.+)"$/ do |name|
  DataRecord.last.lead_organization.name.should == name
end

Then /^I should be browsing filtered by the "([^\"]+)" tag$/ do |tag|
  Then %Q(I should be on the browse page)
  Then %Q(I should see "Browse by tag")
  Then %Q(I should see a record tagged "#{tag}")
end

Then /^I should be browsing records created on (\d+)$/ do |year|
  Then %Q(I should be on the browse page)
  Then %Q(the "Release Year" field should contain "#{year}")
end
