class AlertsController < ApplicationController
  before_filter :require_user

  def update
    return unless clean_params
    
    if params[:user][:alert_sms] == '1' and params[:user][:alert_sms_number].blank?
      @alert_user = current_user.dup
      @user = current_user
      @alert_user.errors.add_to_base('Please provide an SMS number')
      render :template => 'users/edit'
      return
    end
    
    @alerts = current_user.alerts.dup
    params[:tags].each do |tag_id|
      params[:locations].each do |location_id|
        next if @alerts.delete(@alerts.detect { |x| x.tag_id == tag_id and x.location_id == location_id }).present?
        current_user.alerts.create(:tag_id => tag_id, :location_id => location_id)
      end
    end
    @alerts.each do |x| x.destroy end
    current_user.update_attributes(params[:user])
    flash[:notice] = 'Successfully saved the notifications.'
    redirect_to edit_profile_path
  end

  protected
    def clean_params # This may be in need of refactoring
      if params[:locations].include?('0') and params[:tags].include?('Select Topics')
        @user = current_user.dup
        @alert_user = current_user
        @alert_user.attributes = params[:user]
        @alert_user.errors.add_to_base('You must include a Topic and a Coverage')
        render :template => 'users/edit'
        return false
      end
      params[:tags].delete('0') if params[:tags].include?('0')
      params[:locations].delete('0') if params[:locations].include?('0')
      params[:tags] = [0] if params[:tags].include?('All')
      params[:locations] = [1] if params[:locations].include?('1')
      params[:tags].collect! { |x| x.to_i }
      params[:tags].uniq!
      params[:tags] =[nil] if params[:tags].include?(0) or params[:tags].blank?
      params[:locations].collect! {|x| x.to_i }
      params[:locations].uniq!
      params[:locations] = [nil] if params[:locations].blank?
      true
    end

end
