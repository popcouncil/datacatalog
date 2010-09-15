class AddRoleToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :role, :string
    remove_column :users, :api_key
  end

  def self.down
    add_column :users, :api_key, :string
    remove_column :users, :role
  end
end
