class AddOrganizationToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :affiliation_id, :integer

    User.find_each do |user|
      if user[:affiliation].present?
        org = Organization.find_or_create_by_name(user[:affiliation])
        user[:affiliation_id] = org.id
        user.save
      end
    end

    remove_column :users, :affiliation
  end

  def self.down
    add_column :users, :affiliation, :string

    User.find_each do |user|
      if user[:affiliation_id].present?
        user[:affiliation] = Organization.find(user[:affiliation_id])
        user.save
      end
    end

    remove_column :users, :affiliation_id
  end
end
