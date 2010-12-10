class AddDataUncoveredOptInToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :data_uncovered_opt_in, :boolean
  end

  def self.down
    remove_column :users, :data_uncovered_opt_in
  end
end
