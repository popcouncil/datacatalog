class DataRecordLocation < ActiveRecord::Base
  DISAGGREGATION_LEVELS = %w(1st\ Administrative\ Level\
                             2nd\ Administrative\ Level\
                             3rd\ Administrative\ Level\
                             Borough
                             City
                             Commune
                             Constituency
                             County
                             Department
                             Dependency
                             District
                             Division
                             Emirate
                             Governorate
                             Kingdom
                             Local Council
                             Municipanity
                             Parish
                             Prefecture
                             Province
                             Region
                             State
                             Sub-County
                             Territory
                             Town
                             Township
                             Village)
  
  
  belongs_to :data_record
  belongs_to :location
  before_save :set_default_disaggregation_level
  
  protected
    def set_default_disaggregation_level
      self[:disaggregation_level] = "Global" if location.global?
      self[:disaggregation_level] = "World Regions" if location.region?
    end
end
