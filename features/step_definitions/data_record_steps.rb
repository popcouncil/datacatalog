Given /^a data record titled "(.*)" exists$/ do |title|
  Given %Q(an organization named "Red Cross" exists)

  the.data_record = DataRecord.create(
    :title           => title,
    :description     => "Some Description",
    :country         => "Namibia",
    :homepage_url    => "http://namibia.com/data",
    :year            => "2008",
    :status          => "Published",
    :organization_id => the.organization.id
  ) do |data_record|
    data_record.documents << Document.new(:external_url => "http://namibia.com/data/document")
  end
end

Given /^I favorited the data record$/ do
  the.user.favorite_records << the.data_record
end

Then /^I should see the favorited data record$/ do
  Then %Q(I should see "#{the.data_record.title}")
end
