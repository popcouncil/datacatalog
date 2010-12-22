class AlertsController < ApplicationController
  before_filter :require_user

  def update
    @alert = current_user.alerts.find(params[:id])
    if @alert.update_attributes(params[:alert])
      flash[:notice] = 'Successfully saved the notification.'
      redirect_to edit_profile_path
    else
      @user = current_user
      @alerts = current_user.alerts
      @alerts.delete(@alert)
      @alerts << @alert
      render :template => 'users/edit'
    end
  end

  def create
    if current_user.alerts.count >= 5
      flash[:notice] = 'You may only add up to 5 notifications.'
      redirect_to(edit_profile_path)
      return 
    end
    params[:alert].delete(:tag_id) if params[:alert][:tag_id] == 'All'
    @alert = current_user.alerts.new(params[:alert])
    if @alert.save
      flash[:notice] = 'Successfully created the notification.'
      redirect_to edit_profile_path
    else
      @user = current_user
      @alerts = current_user.alerts
      @alerts.delete(@alert)
      @alerts << @alert
      render :template => 'users/edit'
    end
  end
end
