class CommentsController < ApplicationController
  def create
    @data_record = DataRecord.find_by_slug(params[:data_record_id])
    @comments = @data_record.comment_threads
    @comment = @comments.new(:user_id => current_user.id)

    if @comment.update_attributes(params[:comment])
      flash[:notice] = "Comment saved!"
      redirect_to @data_record
    else
      render :template => "data_records/show"
    end
  end
end
