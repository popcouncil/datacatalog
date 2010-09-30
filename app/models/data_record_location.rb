class DataRecordLocation < ActiveRecord::Base
  belongs_to :data_record
  belongs_to :location
end
