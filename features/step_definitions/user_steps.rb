Then /^a new (.*) account should be created with "(.*)"$/ do |role, email|
  user = User.find_by_email(email)
  user.should send("be_#{role}")
end

Then /^a new (?:.*) account should not be created with "(.*)"$/ do |email|
  user = User.find_by_email(email)
  user.should be_nil
end
