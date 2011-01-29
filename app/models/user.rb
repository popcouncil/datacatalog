class User < ActiveRecord::Base
  EMAIL_REGEX = /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/

  USER_TYPES = %w(Government Journalism Non-Profit Policy Student Research) << 'Other data lover'
  ROLES = { "Admin" => :admin, "Ministry User" => :ministry_user, "Normal User" => :basic }

  has_many :notes,     :dependent => :destroy
  has_many :ratings,   :dependent => :destroy
  has_many :favorites, :dependent => :destroy
  has_many :favorite_records, :through => :favorites, :source => :data_record
  has_many :data_records, :foreign_key => :owner_id, :dependent => :nullify
  has_many :alerts, :dependent => :destroy

  belongs_to :affiliation, :class_name => "Organization"
  belongs_to :location

  validates_presence_of :email, :display_name#, :location, :city, :user_type
  validates_inclusion_of :user_type, :in => USER_TYPES, :allow_blank => true
  validates_inclusion_of :role, :in => ROLES.values.map(&:to_s)

  before_validation_on_create :set_default_role
  before_save :link_organization

  after_save :save_wordpress
  after_destroy :destroy_wordpress
  before_save :'call_wordpress?'
  before_destroy :'call_wordpress?'

  named_scope :alphabetical, :order => 'display_name'

  named_scope :admins,         :conditions => { :role => "admin" }
  named_scope :ministry_users, :conditions => { :role => "ministry_user" }

  acts_as_authentic do |config|
    config.openid_required_fields = [:nickname, :email]
  end

  acts_as_tagger

  # It really should be name, not display_name
  alias_attribute :name, :display_name
  attr_accessor :call_wordpress

  def self.search(term)
    return alphabetical if term.blank?

    if term =~ EMAIL_REGEX
      all(:conditions => { :email => term })
    else
      all(:conditions => ["display_name LIKE ?", "%#{term}%"])
    end
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

  def favorite?(data_record)
    favorite_records.include?(data_record)
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

  def affiliation_name=(name)
    @affiliation_name = name
  end

  def affiliation_name
    if defined?(@affiliation_name)
      @affiliation_name
    else
      affiliation.try(:name)
    end
  end

  def alert_topics
    self.alerts.all.collect do |x| x.tag_id end.uniq
  end

  def alert_topics_list
    self.alerts.all.collect(&:tag_name).uniq
  end

  def alert_locations
    self.alerts.all.collect do |x| x.location_id end.uniq
  end

  def alert_locations_list
    self.alerts.all.collect(&:location_name).uniq
  end

  # Wordpress related stuff
  def save_wordpress
    return unless @call_wordpress
    begin
      Net::HTTP.post_form(URI.parse(ENV['WORDPRESS_URL']), {:callback => 'save', :payload => self.wpdata})
    rescue
      false
    end
  end

  def destroy_wordpress
    return if @call_wordpress
    begin
      Net::HTTP.post_form(URI.parse(ENV['WORDPRESS_URL']), {:callback => 'destroy', :payload => self.wpdata})
    rescue
      false
    end
  end

  def call_wordpress?
    @call_wordpress = !ENV['WORDPRESS_URL'].blank? and (self.changed & ['email', 'display_name', 'personal_url']).length > 1
    true
  end
  
  def wpdata(login = false)
    if login
      data = {:ID => self.id, :time => Time.now.to_i}
    else
      data = {:ID => self.id,
        :user_login => self.email,
        :user_email => self.email,
        :user_nicename => self.display_name,
        :display_name => self.display_name,
        :user_url => self.personal_url
        }
      data.merge!(:user_pass => self.password) unless self.password.blank?
      data.merge!(:role => 'administrator') if self.admin?
    end
    result = ''
    cipher = OpenSSL::Cipher::Cipher.new('AES-128-CBC')
    cipher.encrypt
    cipher.key = OpenSSL::Digest.digest('sha1', ENV['WORDPRESS_KEYCODE'])
    cipher.update(data.to_json, result)
    result << cipher.final
    Base64.encode64(result)
  end

  def self.from_wpdata(data)
    cipher = OpenSSL::Cipher::Cipher.new('AES-128-CBC')
    cipher.decrypt
    cipher.key = OpenSSL::Digest.digest('sha1', ENV['WORDPRESS_KEYCODE'])
    result = ''
    data = Base64.decode64(data)
    cipher.update(data, result)
    result << cipher.final
    JSON.parse(result)
  end
  # End wordpress related stuff

  def gravatar_hash
    Digest::MD5.hexdigest (self.email || '').strip.downcase
  end

  def gravatar_link
    "http://www.gravatar.com/avatar/#{self.gravatar_hash}"
  end

  private

  def map_openid_registration(registration)
    self.email = registration["email"] if email.blank?
    self.display_name = registration["nickname"] if display_name.blank?
  end

  def set_default_role
    self.role = "basic" if role.blank?
  end

  def link_organization
    if affiliation_name.present?
      org = Organization.find_or_create_by_name(:name => affiliation_name, :location => location)
      self.affiliation = org
    end
  end
end
