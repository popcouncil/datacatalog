class CreateDataRecordsPeopleAndCatalogs < ActiveRecord::Migration
  def self.up
    create_table :data_records do |t|
      t.string :title
      t.string :slug
      t.string :homepage_url
      t.text   :description
      t.string :country
      t.string :status
      t.string :project_name
      t.string :funder
      t.string :year

      t.string :organization_id # until we remove the API dependency

      t.belongs_to :owner
      t.belongs_to :catalog
      t.belongs_to :author
      t.belongs_to :contact

      t.timestamps
    end

    create_table :people do |t|
      t.string :name
      t.string :phone
      t.string :email
      t.string :affiliation

      t.string :type
      t.timestamps
    end

    create_table :catalogs do |t|
      t.string :title
      t.string :url
      t.timestamps
    end
  end

  def self.down
    drop_table :catalogs
    drop_table :people
    drop_table :data_records
  end
end
