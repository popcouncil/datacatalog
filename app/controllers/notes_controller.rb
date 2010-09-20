class NotesController < ApplicationController
  before_filter :load_data_record

  def index
    @notes = @data_record.annotations_by(current_user)
  end

  def create
    attributes = params[:note].merge(:user_id => current_user.id)
    note = @data_record.notes.create(attributes)
    flash[:notice] = "Added note."
    redirect_to :back
  end
  
  private

  def load_data_record
    @data_record = DataRecord.find_by_slug(params[:data_record_id])
  end
end
