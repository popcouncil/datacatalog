require 'machinist/active_record'
require 'sham'
require 'faker'

DataRecord.blueprint do
  title        { Faker::Lorem.sentence }
  description  { Faker::Lorem.paragraph }
  country      "Ethiopia"
  year         1990
  owner        { User.make }
  organization { Organization.first || Organization.make }
end

User.blueprint do
  display_name          { Faker::Name.name }
  email                 { Faker::Internet.email }
  password              "test"
  password_confirmation "test"
  country               "Uganda"
  city                  "Kampala"
  user_type             "Journalist"
  role                  "basic"
end

Organization.blueprint do
  name      { Faker::Company.name }
  country   "Afghanistan"
  url       { Faker::Internet.domain_name }
  org_type  "Governmental"
end

Document.blueprint do
  format       "CSV"
  external_url "http://url.com/file.csv"
end
