ENV["RAILS_ENV"] = "cucumber"

Dir[Pathname(__FILE__).dirname.join("helpers/**/*.rb")].each {|f| require f }

require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
require 'cucumber/rails/world'
require 'cucumber/formatter/unicode'
require 'capybara/rails'
require 'capybara/cucumber'
require 'cucumber/rails/rspec'
require 'database_cleaner'
require 'database_cleaner/cucumber'

DatabaseCleaner.strategy = :truncation

ActionController::Base.class_eval do

  private

  def begin_open_id_authentication(identity_url, options = {})
    yield OpenIdAuthentication::Result.new(:successful), normalize_identifier(identity_url), nil
  end

end

World(DefiniteArticleHelper)

Before do
  DatabaseCleaner.start

  # Remove all the users and sources from the local API
  DataCatalog::User.all.each do |u|
    DataCatalog::User.destroy(u.id) unless u.name == "Primary Admin"
  end

  DataCatalog::Source.all.each do |s|
    DataCatalog::Source.destroy(s.id)
  end
end

After do
  DatabaseCleaner.clean
end
