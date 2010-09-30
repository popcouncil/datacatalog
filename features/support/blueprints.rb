require 'machinist/active_record'
require 'sham'
require 'faker'

DataRecord.blueprint do
  title                  { Faker::Lorem.sentence }
  description            { Faker::Lorem.paragraph }
  data_record_locations  { [DataRecordLocation.new(:location_id => Location.all.random_element.id)] }
  year                   1990
  owner                  { User.make }
  lead_organization_name { (Organization.first || Organization.make).name }
  tag_list               "foo, bar, baz"
end

User.blueprint do
  display_name          { Faker::Name.name }
  email                 { Faker::Internet.email }
  password              "test"
  password_confirmation "test"
  location              { Location.countries.random_element }
  city                  "Kampala"
  user_type             "Journalist"
  role                  "basic"
end

Organization.blueprint do
  name      { Faker::Company.name }
  location  { Location.countries.random_element }
  url       { Faker::Internet.domain_name }
  org_type  "Governmental"
end

Document.blueprint do
  format       "CSV"
  external_url "http://url.com/file.csv"
end
