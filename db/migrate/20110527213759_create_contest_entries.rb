class CreateContestEntries < ActiveRecord::Migration
  def self.up
    create_table :contest_entries do |t|
      t.references :contest_registration
      t.string :title
      t.text :summary
      t.string :program_url
      t.string :video_url
      t.string :photo_url
      t.string :file_file_name
      t.integer :file_file_size
      t.string :file_content_type
      t.datetime :file_updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :contest_entries
  end
end
