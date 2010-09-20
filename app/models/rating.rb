class Rating < ActiveRecord::Base
  belongs_to :user
  belongs_to :data_record

  validates_numericality_of :value, :greater_than_or_equal => 1,
                                    :lower_than_or_equal   => 5
end
