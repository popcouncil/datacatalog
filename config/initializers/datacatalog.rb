# Be sure to restart your server when you modify this file.

api_file = Rails.root.join("config/api.yml")
if api_file.file?
  api_config = YAML.load_file(api_file)
  api_config_env = api_config.fetch(Rails.env)
else
  api_config_env = {
    "api_key"  => ENV["API_KEY"],
    "base_uri" => ENV["API_BASE_URI"]
  }
end

DataCatalog.api_key  = api_config_env.fetch('api_key') {
  raise %(api_key not found for environment "#{RAILS_ENV}" in #{file})
}

DataCatalog.base_uri = api_config_env.fetch('base_uri') {
  raise %(base_uri not found for environment "#{RAILS_ENV}" in #{file})
}
