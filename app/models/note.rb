class Note < ActiveRecord::Base
  belongs_to :user
  belongs_to :data_record

  validates_presence_of :text
end
