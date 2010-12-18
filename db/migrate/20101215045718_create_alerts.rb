class CreateAlerts < ActiveRecord::Migration
  def self.up
    create_table :alerts do |t|
      t.references :user
      t.references :tag
      t.references :location
      t.boolean :by_email
      t.boolean :by_sms
      t.string :sms

      t.timestamps
    end
  end

  def self.down
    drop_table :alerts
  end
end
