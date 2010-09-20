class CreateOrganizations < ActiveRecord::Migration
  def self.up
    create_table :organizations do |t|
      t.string :name
      t.string :country
      t.string :acronym
      t.string :org_type
      t.text :description
      t.string :slug
      t.string :url
      t.string :homepage_url
      t.belongs_to :parent
      t.integer :lft
      t.integer :rgt
      t.timestamps
    end
  end

  def self.down
    drop_table :organizations
  end
end
