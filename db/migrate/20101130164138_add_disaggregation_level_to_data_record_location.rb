class AddDisaggregationLevelToDataRecordLocation < ActiveRecord::Migration
  def self.up
    add_column(:data_record_locations, :disaggregation_level, :string)
  end

  def self.down
    remove_column(:data_record_locations, :disaggregation_level)
  end
end
