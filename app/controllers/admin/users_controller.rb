class Admin::UsersController < AdminController

  before_filter :require_admin

  def index
    @term = params[:search]
    @users = User.search(@term)
    @admins = User.admins
  end

  def show
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      flash[:notice] = "Profile updated!"
      redirect_to :back
    else
      flash[:error] = "Error updating!"
      render :show
    end
  end

  def new
    @user = User.new(:role => :basic)
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      @user.confirm!
      @user.deliver_admin_welcome!

      flash[:notice] = "The user was created and notified."
      redirect_to admin_users_path
    else
      flash[:error] = "Error creating user"
      render :new
    end
  end
end
