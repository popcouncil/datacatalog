class LevelOfDisaggregation < ActiveRecord::Migration
  def self.up
    add_column :data_records, :level_disaggregation, :string
  end

  def self.down
    remove_column :data_records, :level_disaggregation
  end
end
