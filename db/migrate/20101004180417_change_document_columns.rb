class ChangeDocumentColumns < ActiveRecord::Migration
  def self.up
    add_column :documents, :title, :string
    rename_column :documents, :format, :document_type
  end

  def self.down
    rename_column :documents, :document_type, :format
    remove_column :documents, :title
  end
end
