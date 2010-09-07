class AdminController < ApplicationController
  before_filter :require_user, :require_ministry_user

  def show

  end

  private

  def require_ministry_user
    unless current_user.admin_or_ministry_user?
      store_location
      flash[:error] = "You must be an administrator or ministry user to access that section."
      redirect_to dashboard_path
    end
  end

  def require_admin
    unless current_user.admin?
      store_location
      flash[:error] = "You must be an administrator to access that section."
      redirect_to dashboard_path
    end
  end

end