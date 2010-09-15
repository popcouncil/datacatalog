Given /^a data record titled "(.*)" exists$/ do |title|
  the.data_record = DataRecord.create(
    :title           => title,
    :description     => "Some Description",
    :country         => "Namibia",
    :homepage_url    => "http://namibia.com/data",
    :year            => "2008",
    :status          => "Published",
    :organization_id => DataCatalog::Organization.first.id
  ) do |data_record|
    data_record.documents << Document.new(:external_url => "http://namibia.com/data/document")
  end
end

Given /^I favorited the data record$/ do
  the.user.favorite_records << the.data_record
end
