class VotesController < ApplicationController
  def create
    @data_record = DataRecord.find_by_slug(params[:data_record_id])
    @comment = @data_record.comment_threads.find(params[:comment_id])
    @comment.votes.find_or_create_by_user_id(current_user.id)

    flash[:notice] = "Your vote has been added!"
    redirect_to @data_record
  end
end
