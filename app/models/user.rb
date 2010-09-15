# == Schema Information
#
# Table name: users
#
#  id                  :integer(4)      not null, primary key
#  email               :string(255)
#  crypted_password    :string(255)
#  password_salt       :string(255)
#  persistence_token   :string(255)
#  single_access_token :string(255)
#  perishable_token    :string(255)
#  login_count         :integer(4)      default(0)
#  failed_login_count  :integer(4)      default(0)
#  last_request_at     :datetime
#  current_login_at    :datetime
#  last_login_at       :datetime
#  current_login_ip    :string(255)
#  last_login_ip       :string(255)
#  confirmed_at        :datetime
#  openid_identifier   :string(255)
#  display_name        :string(255)
#  api_key             :string(255)
#  country             :string(255)
#  city                :string(255)
#  user_type           :string(255)
#  affiliation         :string(255)
#  personal_url        :string(255)
#  telephone_number    :string(255)

class User < ActiveRecord::Base
  EMAIL_REGEX = /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/

  USER_TYPES = %w(Researcher Journalist Student Other)
  ROLES = { "Admin" => :admin, "Ministry User" => :ministry_user, "Normal User" => :basic }

  validates_presence_of :email, :display_name, :country, :city, :user_type
  validates_inclusion_of :user_type, :in => USER_TYPES
  validates_inclusion_of :role, :in => ROLES.values.map(&:to_s)

  before_validation_on_create :set_default_role

  named_scope :alphabetical, :order => 'display_name'

  named_scope :admins,         :conditions => { :role => "admin" }
  named_scope :ministry_users, :conditions => { :role => "ministry_user" }

  acts_as_authentic do |config|
    config.openid_required_fields = [:nickname, :email]
  end

  acts_as_tagger

  def self.search(term)
    return alphabetical if term.blank?

    if term =~ EMAIL_REGEX
      all(:conditions => { :email => term })
    else
      all(:conditions => ["display_name LIKE ?", "%#{term}%"])
    end
  end

  def favorites
    []
  end

  def confirmed?
    confirmed_at ? true : false
  end

  def confirm!
    self.confirmed_at = Time.now
    save!
  end

  def deliver_confirmation_instructions!
    reset_perishable_token!
    Notifier.deliver_confirmation_instructions(self)
  end

  def deliver_welcome_message!
    reset_perishable_token!
    Notifier.deliver_welcome_message(self)
  end

  def deliver_admin_welcome!
    reset_perishable_token!
    Notifier.deliver_admin_welcome(self)
  end

  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.deliver_password_reset_instructions(self)
  end

  # Use admin?, ministry_user?, and admin_or_ministry_user? for authorization.
  def admin?
    role == "admin"
  end

  # Use admin?, ministry_user?, and admin_or_ministry_user? for authorization.
  def ministry_user?
    role == "ministry_user"
  end

  # Use admin?, ministry_user?, and admin_or_ministry_user? for authorization.
  def admin_or_ministry_user?
    admin? || ministry_user?
  end

  def api_user
    warn "User#api_user is deprecated (called from #{caller.first})"
    self
  end

  private

  def map_openid_registration(registration)
    self.email = registration["email"] if email.blank?
    self.display_name = registration["nickname"] if display_name.blank?
  end

  def set_default_role
    self.role = "basic" if role.blank?
  end
end
