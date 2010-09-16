class CreateNotes < ActiveRecord::Migration
  def self.up
    create_table :notes do |t|
      t.belongs_to :user
      t.belongs_to :data_record
      t.text :text

      t.timestamps
    end
  end

  def self.down
    drop_table :notes
  end
end
