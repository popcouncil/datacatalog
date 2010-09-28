class Sponsor < ActiveRecord::Base
  belongs_to :data_record
  belongs_to :organization
end
