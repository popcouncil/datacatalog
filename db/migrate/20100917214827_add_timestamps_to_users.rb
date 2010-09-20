class AddTimestampsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :updated_at, :datetime
    add_column :users, :created_at, :datetime

    User.find_each do |u|
      u.update_attributes(:created_at => Time.zone.now)
    end
  end

  def self.down
    remove_column :users, :created_at
    remove_column :users, :updated_at
  end
end
