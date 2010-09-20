Given /^the data record is not documented$/ do
  # no-op
end

Given /^the data record is documented$/ do
  the.data_record.create_wiki(:body => "Version 1", :user => the.user)
end

Given /^the data record was documented (\d+) times$/ do |count|
  count.to_i.times do |i|
    wiki = the.data_record.wiki || the.data_record.create_wiki(:user => the.user)
    wiki.update_attributes(:body => "Version #{i}")
  end
end

When /^I browse to the data record's documentation$/ do
  When %Q(I go to the data record's page)
  When %Q(I follow "Community Docs")
end

When /^I write the documentation text$/ do
  if the.data_record.wiki
    When %Q(I follow "edit and improve the documentation")
  else
    When %Q(I follow "writing it")
  end

  When %Q(I fill in "wiki_body" with "New Version")
  When %Q(I press "Update")
end

When /^I browse to the (\w+) revision$/ do |position|
  version = the.data_record.wiki.versions.send(position)

  within :css, "#wiki_version_#{version.id}" do
    When %Q(I follow "minute") # "\d+ minutes" OR "less than a minute"
  end
end

Then /^I should see the data record's documentation$/ do
  Then %Q(I should see "Version #{the.data_record.wiki.version}")
end

Then /^I should see the updated documentation$/ do
  Then %Q(I should see "New Version")
end

Then /^I should see (\d+) versions? in the sidebar$/ do |count|
  page.should have_css("#version_list li.wiki_version", :count => count.to_i)
end

Then /^I should see the (\w+) revision$/ do |position|
  version = the.data_record.wiki.versions.send(position)
  Then %Q(I should see "#{version.body}")
end
