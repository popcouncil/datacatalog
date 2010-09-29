namespace :data do
  desc "Create default locations"
  task :create_locations => :environment do
    require Rails.root.join("db/seeds")
  end
end
