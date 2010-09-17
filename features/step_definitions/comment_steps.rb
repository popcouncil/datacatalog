When /^I write a (?:comment|bug report) for the data record$/ do
  the.comment = "Lorem Ipsum Dolor Sit Amet"
  When %Q(I fill in "Comment" with "#{the.comment}")
end

Then /^I should see my (?:comment|bug report)$/ do
  page.should have_content(the.comment)
end
