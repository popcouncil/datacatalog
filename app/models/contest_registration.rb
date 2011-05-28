class ContestRegistration < ActiveRecord::Base
  serialize :members
  attr_accessor :terms
  validates_inclusion_of :category, :in => %w(Software Journalism)
  validates_presence_of :email, :phone, :city, :address, :affiliation
  validates_acceptance_of :terms
  has_many :contest_entries
  belongs_to :user

  
  def friendly_members
    self.members.collect do |x|
      "Name: #{x['name']} Email: #{x['email']}"
    end
    rescue
      []
  end
end
