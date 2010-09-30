class CreateDataRecordLocations < ActiveRecord::Migration
  def self.up
    create_table :data_record_locations do |t|
      t.belongs_to :data_record
      t.belongs_to :location
      t.timestamps
    end

    DataRecord.class_eval { belongs_to :location }

    DataRecord.find_each do |record|
      record.locations << record.location
    end

    remove_column :data_records, :location_id
  end

  def self.down
    add_column :data_records, :location_id, :integer
    
    DataRecord.class_eval {
      has_many :data_record_locations, :dependent => :destroy
      has_many :locations, :through => :data_record_locations
    }

    DataRecord.find_each do |record|
      record.update_attribute(:location_id, record.locations.first.id)
    end

    drop_table :data_record_locations
  end
end
