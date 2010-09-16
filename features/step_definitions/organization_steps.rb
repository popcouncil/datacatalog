Given /^an organization named "([^\"]+)" exists$/ do |name|
  DataCatalog::Organization.create(
    :name      => name,
    :slug      => name.gsub(/\s+/, "_").downcase,
    :url       => "http://google.com/",
    :org_type  => "governmental",
    :top_level => true,
    :interest => 1
  )
end
