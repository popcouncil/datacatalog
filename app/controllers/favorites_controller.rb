class FavoritesController < ApplicationController
  def create
    @data_record = DataRecord.find_by_slug(params[:data_record_id])

    unless current_user.favorite?(@data_record)
      current_user.favorites.create(:data_record_id => @data_record.id)
    end

    redirect_to @data_record
  end

  def destroy
    @data_record = DataRecord.find_by_slug(params[:data_record_id])

    if current_user.favorite?(@data_record)
      favorite = current_user.favorites.find_by_data_record_id(@data_record.id)
      favorite.destroy
    end

    redirect_to @data_record
  end
end
