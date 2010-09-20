class CreateWikis < ActiveRecord::Migration
  def self.up
    create_table :wikis do |t|
      t.belongs_to :data_record
      t.belongs_to :user
      t.text :body
      t.timestamps
    end

    Wiki.reset_column_information
    Wiki.create_versioned_table
  end

  def self.down
    Wiki.drop_versioned_table
    drop_table :wikis
  end
end
