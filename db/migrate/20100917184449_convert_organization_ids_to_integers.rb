class ConvertOrganizationIdsToIntegers < ActiveRecord::Migration
  def self.up
    remove_column :data_records, :organization_id
    add_column :data_records, :organization_id, :integer
  end

  def self.down
    remove_column :data_records, :organization_id
    add_column :data_records, :organization_id, :string
  end
end
