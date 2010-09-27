Given /^an organization named "([^\"]+)" exists$/ do |name|
  the.organization = Organization.make(:name => name)
end

Then /^the organization's parent should be "([^\"]+)"$/ do |parent|
  within :css, "#organization_parent_id option[selected]" do
    page.should have_content(parent)
  end
end

Then /^there should be (\w+) organizations?$/ do |count|
  Organization.count.should == count.to_i
end
