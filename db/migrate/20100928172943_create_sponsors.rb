class CreateSponsors < ActiveRecord::Migration
  def self.up
    create_table :sponsors do |t|
      t.belongs_to :data_record
      t.belongs_to :organization
      t.boolean :lead
      t.timestamps
    end

    DataRecord.find_each do |record|
      if record.respond_to?(:organization_id)
        record.sponsors.create(:lead => true, :organization => Organization.find(record.organization_id))      
      end
    end

    remove_column :data_records, :organization_id
  end

  def self.down
    drop_table :sponsors
  end
end
