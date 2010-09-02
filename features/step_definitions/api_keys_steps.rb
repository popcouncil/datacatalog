Given /^I have an existing application key with "([^\"]*)" as its purpose$/ do |purpose|
  @user.api_user.generate_api_key!(:key_type => "application", :purpose => purpose)
end

When /^I choose to "([^\"]*)" that key$/ do |action|
  click_link action
end
