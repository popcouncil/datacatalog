class RemoveDuplicateSponsors < ActiveRecord::Migration
  def self.up
    dont_delete = []

    Sponsor.find_each(:conditions => { :lead => true }) do |sponsor|
      dont_delete << sponsor.id

      Sponsor.destroy_all [
        'organization_id = :org AND data_record_id = :dr AND id NOT IN (:ids)',
        { :org => sponsor.organization_id, :dr => sponsor.data_record_id, :ids => dont_delete }
      ]
    end
  end

  def self.down
  end
end
