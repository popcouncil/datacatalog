Then /^I should not see fields for name or email$/ do
  page.should_not have_css("#contact_submission_name")
  page.should_not have_css("#contact_submission_email")
end
