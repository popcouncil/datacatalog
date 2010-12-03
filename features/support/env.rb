ENV["RAILS_ENV"] = "cucumber"

Dir[File.dirname(__FILE__) + "/helpers/**/*.rb"].each {|f| require f }


require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
require 'cucumber/rails/world'
require 'cucumber/formatter/unicode'
require 'capybara/rails'
require 'capybara/cucumber'
require 'cucumber/rails/rspec'
require 'database_cleaner'
require 'database_cleaner/cucumber'
require File.expand_path('../blueprints', __FILE__)
require File.expand_path('../paths',__FILE__)

DatabaseCleaner.strategy = :truncation, {:except => %w[locations]}

ActionController::Base.class_eval do

  private

  def begin_open_id_authentication(identity_url, options = {})
    yield OpenIdAuthentication::Result.new(:successful), normalize_identifier(identity_url), nil
  end

end

World(DefiniteArticleHelper)

Before do
  if Location.count == 0
  require Rails.root.join("db/seeds.rb")
  end
end