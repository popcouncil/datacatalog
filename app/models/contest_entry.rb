class ContestEntry < ActiveRecord::Base
  belongs_to :contest_registration
  has_attached_file :file, PAPERCLIP_CONFIG
  attr_accessor :terms
  validates_acceptance_of :terms
  validates_presence_of :title, :summary

  def defaults(d)
    d.each_pair do |k, v|
      self[k] ||= v
    end
  end

end
