class AddAffiliationIdToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :affiliation_id, :integer
    add_column :people, :data_record_id, :integer

    DataRecord.class_eval { belongs_to :author }
    Author.class_eval     { has_one :data_record }

    Author.find_each(:include => :data_record) do |author|
      author.affiliation_name = author[:affiliation]
      author.data_record_id = DataRecord.find_by_author_id!(author.id).id
      author.save!
    end

    remove_column :people, :affiliation
    remove_column :data_records, :author_id
  end

  def self.down
    add_column :people, :affiliation, :string
    add_column :data_records, :author_id, :integer

    Author.class_eval { belongs_to :data_record }

    Author.find_each(:include => :data_record) do |author|
      author[:affiliation] = Organization.find_by_id(author[:affiliation_id]).try(:name)
      author.save!

      data_record = DataRecord.find(author.data_record_id)
      data_record.author_id = author.id
      data_record.save(false)
    end

    remove_column :people, :data_record_id
    remove_column :people, :affiliation_id
  end
end
