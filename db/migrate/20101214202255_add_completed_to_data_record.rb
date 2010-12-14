class AddCompletedToDataRecord < ActiveRecord::Migration
  def self.up
    add_column(:data_records, :completed, :boolean, :default => false)
  end

  def self.down
    remove_column(:data_records, :completed)
  end
end
