class WikisController < ApplicationController
  before_filter :load_data_record

  def show
    @wiki = @data_record.wiki
    @current_version = @wiki.at(params[:version]) if @wiki
  end

  def edit
    @wiki = @data_record.wiki || @data_record.build_wiki
    @current_version = @wiki.at(params[:version]) if @wiki
  end

  def update
    @wiki = @data_record.wiki || @data_record.build_wiki
    @current_version = @wiki.at(params[:version]) if @wiki
    attributes = params[:wiki].merge(:user_id => current_user.id)

    if @wiki.update_attributes(attributes)
      flash[:notice] = "Updated documentation."
      redirect_to data_record_wiki_path(@data_record)
    else
      render :edit
    end
  end

  private

  def load_data_record
    @data_record = DataRecord.find_by_slug(params[:data_record_id])
  end
end
