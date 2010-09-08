Then /^a new (.*) account should be created with "(.*)"$/ do |role_label, email|
  role = User::ROLES[role_label]
  user = User.find_by_email(email)
  user.api_user.role.should == role.to_s
end

Then /^a new (?:.*) account should not be created with "(.*)"$/ do |email|
  user = User.find_by_email(email)
  user.should be_nil
end
