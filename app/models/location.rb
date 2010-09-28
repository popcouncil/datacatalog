class Location < ActiveRecord::Base
  belongs_to :parent

  validates_presence_of :name
  validates_uniqueness_of :name

  acts_as_nested_set
end
