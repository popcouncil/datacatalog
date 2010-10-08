class Rating < ActiveRecord::Base
  belongs_to :user
  belongs_to :data_record, :counter_cache => true

  validates_numericality_of :value, :greater_than_or_equal => 1,
                                    :lower_than_or_equal   => 5

  before_save   :update_rating_total
  after_destroy :remove_rating_total

  private

  def update_rating_total
    data_record.decrement(:ratings_total, value_was) if value_was.to_i > 0
    data_record.increment(:ratings_total, value)
    data_record.save(false)
  end

  def remove_rating_total
    data_record.decrement(:ratings_total, value)
  end
end
