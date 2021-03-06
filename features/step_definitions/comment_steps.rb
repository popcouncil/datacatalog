Given /^the data record has (\d+) comments?(?: with no votes)?$/ do |count|
  count.to_i.times do |i|
    When %Q(I write a comment for the data record)
    And %Q(I press "Post Comment")
  end
end

When /^I write a (?:comment|bug report) for the data record$/ do
  the.comment = "Lorem Ipsum Dolor Sit Amet"
  When %Q(I fill in "Comment" with "#{the.comment}")
end

When /^I vote for the (\w+) one$/ do |position|
  comment = the.data_record.comment_threads.send(position)

  within :css, "#comment_#{comment.id}" do
    When %Q(I press "Vote This Comment Up")
  end
end

When /^I reply to the (\w+) one$/ do |position|
  comment = the.data_record.comment_threads.send(position)

  within :css, "#comment_#{comment.id}" do
    When %Q(I follow "Reply to This")
  end

  When %Q(I fill in "Comment" with "The Reply")
  When %Q(I press "Post Comment")
end

Then /^I should see my (?:comment|bug report)$/ do
  page.should have_content(the.comment)
end

Then /^the (\w+) comment should have (\w+) votes?$/ do |position, count|
  count = count == "no" ? 0 : count
  comment = the.data_record.comment_threads.send(position)

  within :css, "#comment_#{comment.id} .ratingNumber" do
    Then %Q(I should see "#{count}")
  end
end

Then /^I should not be able to vote for the (\w+) comment$/ do |position|
  comment = the.data_record.comment_threads.send(position)

  within :css, "#comment_#{comment.id}" do
    Then %Q(I should not see "Vote This Comment Up")
  end
end

Then /^the (\w+) comment should( not)? have a reply$/ do |position, negative|
  comment = the.data_record.comment_threads.send(position)
  within :css, "#comment_#{comment.id}" do
    Then %Q(I should#{negative} see "The Reply")
  end
end
