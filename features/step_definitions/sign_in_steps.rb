Given /^I am signed in$/ do
  Given %Q(I have signed up with "some@email.com")
  @user = User.find_by_email(the.user.email)
  visit signin_path
  fill_in("Email", :with => "some@email.com")
  fill_in("Password", :with => "test")
  click_button("Sign In")
end

Given /^I am a signed in (.*)$/ do |role|
  Given %Q(I have signed up with "some@email.com")
  the.user.role = case role
    when "user"; "basic"
    when "ministry user"; "ministry_user"
    else role
  end
  the.user.save!

  visit signin_path
  fill_in("Email", :with => "some@email.com")
  fill_in("Password", :with => "test")
  click_button("Sign In")
end

Given /^I am signed in as "([^\"]+)"$/ do |email|
  the.user = User.find_by_email(email)
  visit signin_path
  fill_in "Email",    :with => email
  fill_in "Password", :with => "test"
  click_button "Sign In"
end
