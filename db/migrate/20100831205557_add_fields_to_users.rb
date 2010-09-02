class AddFieldsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :affiliation, :string
    add_column :users, :country, :string
    add_column :users, :city, :string
    add_column :users, :personal_url, :string
    add_column :users, :telephone_number, :string
    add_column :users, :user_type, :string
  end

  def self.down
    remove_column :users, :user_type
    remove_column :users, :telephone_number
    remove_column :users, :personal_url
    remove_column :users, :city
    remove_column :users, :country
    remove_column :users, :affiliation
  end
end
