class AddViewsToDataRecord < ActiveRecord::Migration
  def self.up
    add_column :data_records, :views_count, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column :data_records, :views_count
  end
end
