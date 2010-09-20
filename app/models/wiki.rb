class Wiki < ActiveRecord::Base
  belongs_to :data_record
  belongs_to :user

  validates_presence_of :body

  acts_as_versioned do
    def user
      @user ||= User.find(user_id)
    end
  end

  def at(past_version)
    versions.find_by_version(past_version || version)
  end

  Version.class_eval do
    default_scope :order => "version DESC"
  end
end
