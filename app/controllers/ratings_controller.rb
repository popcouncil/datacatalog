class RatingsController < ApplicationController
  def update
    data_record = DataRecord.find_by_slug(params[:data_record_id])
    rating = current_user.ratings.find_or_initialize_by_data_record_id(data_record.id)
    rating.update_attributes(:value => params[:value])
    redirect_to :back
  end
end
