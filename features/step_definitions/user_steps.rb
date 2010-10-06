Given /^an? (.*) named "(.+)" with "(.*)" exists$/ do |role, name, email|
  the.user = User.make(
    :display_name => name,
    :email        => email,
    :role         => normalize_role(role)
  )
  the.user.confirm!
end

Given /^I am affiliated to "(.+)"$/ do |affiliation|
  the.user.update_attributes(:affiliation_name => affiliation)
end

Given /^my (\w+) is "([^\"]+)"$/ do |attribute, value|
  the.user.update_attribute(attribute, value)
end

Then /^a new (.*) account should be created with "(.*)"$/ do |role_label, email|
  role = User::ROLES[role_label]
  user = User.find_by_email(email)
  user.role.should == role.to_s
end

Then /^a new (?:.*) account should not be created with "(.*)"$/ do |email|
  user = User.find_by_email(email)
  user.should be_nil
end

Then /^the user should be affiliated with "(.*)"$/ do |affiliation|
  user = User.last
  user.affiliation.try(:name).to_s.should == affiliation.strip
end
