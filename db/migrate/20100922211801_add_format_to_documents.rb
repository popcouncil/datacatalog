class AddFormatToDocuments < ActiveRecord::Migration
  def self.up
    add_column :documents, :format, :string
  end

  def self.down
    remove_column :documents, :format
  end
end
