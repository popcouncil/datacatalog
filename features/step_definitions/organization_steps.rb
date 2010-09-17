Given /^an organization named "([^\"]+)" exists$/ do |name|
  the.organization = Organization.create(
    :name      => name,
    :country   => "Afghanistan",
    :url       => "http://google.com/",
    :org_type  => "Governmental"
  )
end

Then /^the organization's parent should be "([^\"]+)"$/ do |parent|
  within :css, "#organization_parent_id option[selected]" do
    page.should have_content(parent)
  end
end
