class Admin::UsersController < AdminController

  before_filter :require_admin

  EMAIL_REGEX = /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/

  def index
    @search_term = params[:search]
    @users = if @search_term
      if @search_term =~ EMAIL_REGEX
        User.find_all_by_email(@search_term)
      else
        User.find(:all, :conditions =>
          ["display_name LIKE ?", "%#{@search_term}%"])
      end
    else
      User.alphabetical
    end
    @admins = User.admins
  end

  def show
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    role = params[:user].delete(:role)

    if @user.update_attributes(params[:user])
      @user.update_role(role, current_user.api_key) if role.present?
      flash[:notice] = "Profile updated!"
      redirect_to :back
    else
      flash[:error] = "Error updating!"
      render :show
    end
  end

  def new
    @user = User.new
  end

  def create
    role = params[:user].delete(:role)
    @user = User.new(params[:user])

    if @user.save
      @user.confirm!
      @user.update_role(role, current_user.api_key) if role.present?
      @user.deliver_admin_welcome!

      flash[:notice] = "The user was created and notified."
      redirect_to admin_users_path
    else
      flash[:error] = "Error creating user"
      render :new
    end
  end
end
