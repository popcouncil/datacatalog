class AddLocationFields < ActiveRecord::Migration
  def self.up
    say_with_time "Creating default locations" do
      Rake::Task["data:create_locations"].invoke unless Location.count > 0
    end

    add_column :users,         :location_id, :integer
    add_column :data_records,  :location_id, :integer
    add_column :organizations, :location_id, :integer

    say_with_time "Updating user locations" do
      User.find_each do |user|
        user.update_attribute(:location_id, Location.find_by_name(user[:country]).id)
      end
    end

    say_with_time "Updating data record locations" do
      DataRecord.find_each do |record|
        record.update_attribute(:location_id, Location.find_by_name(record[:country]).id)
      end
    end

    say_with_time "Updating organization locations" do
      Organization.find_each do |org|
        org.update_attribute(:location_id, Location.find_by_name(org[:country]).id)
      end
    end

    remove_column :organizations, :country
    remove_column :data_records,  :country
    remove_column :users,         :country
  end

  def self.down
    add_column :users,         :country, :string
    add_column :data_records,  :country, :string
    add_column :organizations, :country, :string

    User.class_eval { belongs_to :location }
    DataRecord.class_eval { belongs_to :location }
    Organization.class_eval { belongs_to :location }

    say_with_time "Updating user locations" do
      User.find_each do |user|
        user.update_attribute(:country, user.location.name)
      end
    end

    say_with_time "Updating data record locations" do
      DataRecord.find_each do |record|
        record.update_attribute(:country, record.location.name)
      end
    end

    say_with_time "Updating organization locations" do
      Organization.find_each do |org|
        org.update_attribute(:country, org.location.name)
      end
    end

    remove_column :organizations, :location_id
    remove_column :data_records,  :location_id
    remove_column :users,         :location_id
  end
end
