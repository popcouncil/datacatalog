class CreateContestRegistrations < ActiveRecord::Migration
  def self.up
    create_table :contest_registrations do |t|
      t.string :contest
      t.string :category
      t.boolean :team
      t.text :members
      t.string :affiliation
      t.string :email
      t.string :phone
      t.string :address
      t.string :city
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :contest_registrations
  end
end
