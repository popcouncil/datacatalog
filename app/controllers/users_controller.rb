class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create, :confirm]
  before_filter :require_user, :only => [:show, :edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      @user.confirm!
      if @user.openid_identifier.present?
        @user.deliver_welcome_message!
        UserSession.create(@user)
        flash[:notice] = "Success! You have been signed in."
        redirect_to edit_profile_path
      else
        @user.deliver_confirmation_instructions!
        flash[:notice] = "Your account has been created. Please check your email inbox to confirm your email address."
        redirect_to edit_profile_path
      end
    else
      render :action => :new
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update_attributes(params[:user])
      flash[:notice] = "Profile updated!"
      redirect_to edit_profile_path
    else
      render :edit
    end
  end

  def confirm
    @user = User.find_using_perishable_token(params[:token], 1.month)
    if @user.nil? || @user.confirmed?
      flash[:notice] = "No confirmation needed! Try signing in."
      redirect_to signin_path
    elsif @user.confirm!
      @user.deliver_welcome_message!
      UserSession.create(@user)
      flash[:notice] = "Thanks! Your email address has been confirmed and you're now signed in."
      redirect_to edit_profile_path
    else
      flash[:error] = "Sorry, could not confirm the email address."
      redirect_to signup_path
    end
  end
end
