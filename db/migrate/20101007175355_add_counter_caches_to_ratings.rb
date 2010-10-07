class AddCounterCachesToRatings < ActiveRecord::Migration
  def self.up
    add_column :data_records, :ratings_count, :integer, :default => 0
    add_column :data_records, :ratings_total, :integer, :default => 0

    Rating.class_eval { belongs_to :data_record } # without :counter_cache => true

    say_with_time "Updating ratings to use the cache" do
      DataRecord.find_each do |data_record|
        data_record.update_attribute(:ratings_count, data_record.ratings.length)
        data_record.update_attribute(:ratings_total, data_record.ratings.sum(:value))
      end
    end
  end

  def self.down
    remove_column :data_records, :ratings_total
    remove_column :data_records, :ratings_count
  end
end
