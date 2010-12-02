class Location < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name

  acts_as_nested_set

  def self.global
    find_by_name! "Global"
  end

  def self.continents
    global.children
  end

  def self.countries
    global.leaves
  end
  
  def global?
    self.name == "Global"
  end
  
  def region?
    Location.continents.include?(self)
  end
end
