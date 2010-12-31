class AddAlertToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :alert_email, :boolean
    add_column :users, :alert_sms, :boolean
    add_column :users, :alert_sms_number, :string
    remove_column :alerts, :by_sms
    remove_column :alerts, :by_email
    remove_column :alerts, :sms
  end

  def self.down
    remove_column :users, :alert_sms_number
    remove_column :users, :alert_sms
    remove_column :users, :alert_email
  end
end
