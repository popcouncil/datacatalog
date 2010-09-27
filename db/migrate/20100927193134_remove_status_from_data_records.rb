class RemoveStatusFromDataRecords < ActiveRecord::Migration
  def self.up
    remove_column :data_records, :status
  end

  def self.down
    add_column :data_records, :status, :string
  end
end
