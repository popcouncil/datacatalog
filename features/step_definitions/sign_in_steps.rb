Given /^I am signed in$/ do
  Given %Q(I have signed up with "some@email.com")
  @user = User.find_by_api_key(the.user.api_key)
  visit signin_path
  fill_in("Email", :with => "some@email.com")
  fill_in("Password", :with => "test")
  click_button("Sign In")
end
