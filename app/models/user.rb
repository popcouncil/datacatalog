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
  USER_TYPES = %w(Researcher Journalist Student Other)
  ROLES = { "Admin" => :admin, "Ministry User" => :ministry_user, "Normal User" => :basic }

  validates_presence_of :email, :display_name, :country, :city, :user_type
  validates_inclusion_of :user_type, :in => USER_TYPES
  validates_inclusion_of :role, :in => ROLES.values.map(&:to_s)

  attr_writer :api_user
  attr_reader :ministry_user

  before_validation_on_create :set_default_role
  before_save :set_update_params
  after_save :update_api_user

  acts_as_authentic do |config|
    config.openid_required_fields = [:nickname, :email]
  end

  acts_as_tagger

  named_scope :alphabetical, :order => 'display_name'

  def self.admins
    self.all.select { |u| u.admin? }
  end

  def self.ministry_users
    self.all.select { |u| u.ministry_user? }
  end

  def api_user
    @api_user ||= self.api_key ? DataCatalog::User.get_by_api_key(self.api_key) : nil
  rescue ActiveRecord::MissingAttributeError, DataCatalog::NotFound
    nil
  end

  def ministry_user=(is_ministry_user)
    self.role = "ministry_user" if !!is_ministry_user
  end

  def set_update_params
    @updated_params = {}

    @updated_params[:name] = self.display_name if self.display_name_changed?
    @updated_params[:email] = self.email if self.email_changed?

    @updated_params
  end

  def update_api_user
    self.api_user = DataCatalog::User.update(self.api_user.id, @updated_params) unless self.api_key.nil? || @updated_params.empty?
  end

  def confirmed?
    confirmed_at ? true : false
  end

  def confirm!
    create_api_user
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

  def create_api_user
    if (found_user = DataCatalog::User.first(:email => self.email))
      self.api_user = found_user
    else
      self.api_user = DataCatalog::User.create(:name => self.display_name, :email => self.email)
    end
    self.api_key = self.api_user.primary_api_key
    self.api_id = self.api_user.id
  end

  # Use admin?, ministry_user?, and admin_or_ministry_user? for authorization.
  # Never use ministry_user (sans question mark), as it is an in-memory accessor.
  def admin?
    self.api_user.try(:admin)
  end

  # Use admin?, ministry_user?, and admin_or_ministry_user? for authorization.
  # Never use ministry_user (sans question mark), as it is an in-memory accessor.
  def ministry_user?
    self.api_user.try(:ministry_user)
  end

  # Use admin?, ministry_user?, and admin_or_ministry_user? for authorization.
  # Never use ministry_user (sans question mark), as it is an in-memory accessor.
  def admin_or_ministry_user?
    self.admin? || self.ministry_user?
  end

  def role
    @role ||= api_user.try(:role)
  end

  def role=(role)
    @role = role
  end

  def update_role(role, api_key)
    self.role = role

    DataCatalog.with_key(api_key) do
      DataCatalog::User.update(self.api_user.id, :role => role)
    end
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
