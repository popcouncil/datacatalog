Given /^I am a site visitor$/ do
  visit signout_path
end

Given /^I have signed up(?: with "(.*)")?(?: and confirmed)?$/ do |email|
  Given %Q(I have signed up with "#{email || "some@email.com"}" but not yet confirmed)
  the.user.confirm!
end

Given /^I am a site visitor who already has signed up with "([^\"]*)"$/ do |email|
  Given %Q(I have signed up with "#{email}")
  @user = User.find_by_email(the.user.email)
end

Given /^I am a site visitor who had an admin account created with "([^\"]*)" by an admin$/ do |email|
  Given %Q(I have signed up with "#{email}")
  the.user.role = "admin"
  the.user.save!

  @user = User.find_by_email(the.user.email)
end

Given /^I have signed up(?: with "(.*)")? but not yet confirmed$/ do |email|
  the.user = User.create!(
    :display_name => 'John D.',
    :email => email || 'some@email.com',
    :password => 'test',
    :password_confirmation => 'test',
    :country => 'Uganda',
    :city => 'Kampala',
    :user_type => 'Journalist'
  )
end

Given /^I have signed up via OpenID but not yet confirmed$/ do
  the.user = User.create!(
    :display_name => 'John D.',
    :email => 'some1@email.com',
    :openid_identifier => 'http://someid.com/',
    :country => 'Uganda',
    :city => 'Kampala',
    :user_type => 'Journalist'
  )
end

Given /^I have signed up via OpenID$/ do
  Given "I have signed up via OpenID but not yet confirmed"
  the.user.confirm!
end

When /^I click on the confirmation link$/ do
  unconfirmed_user = User.find_by_email('some@email.com')
  visit confirm_path(:token => unconfirmed_user.perishable_token)
end

Then /^my account should be created$/ do
  @user = User.find_by_email('john@test.com')
  @user.should be_an_instance_of(User)
end

Then /^my OpenID-enabled account should be created$/ do
  @user = User.find_by_openid_identifier('http://johndoe.myopenid.com/')
  @user.should be_an_instance_of(User)
end

Then /^my account should not be created$/ do
  @user = User.find_by_email('jack@test.com')
  @user.should be(nil)
end
