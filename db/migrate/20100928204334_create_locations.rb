class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.string :name
      t.belongs_to :parent
      t.integer :lft
      t.integer :rgt

      t.timestamps
    end
  end

  def self.down
    drop_table :locations
  end
end
