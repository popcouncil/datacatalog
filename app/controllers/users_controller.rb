class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create, :confirm]
  before_filter :require_user, :only => [:show, :edit, :update]

  def new
    @user = User.new
    if params[:from] == 'wordpress' and !ENV['WORDPRESS_REGISTERED'].blank?
      session[:after_registration] = ENV['WORDPRESS_REGISTERED'] #use :return_to ?
    end
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      if @user.openid_identifier.present?
        @user.deliver_welcome_message!
        @user.confirm!
        UserSession.create(@user)
        flash[:notice] = "Success! You have been signed in."
        redirect_to edit_profile_path
      else
        @user.deliver_confirmation_instructions!
        flash[:notice] = "Your account has been created. Please check your email inbox to confirm your email address."
        redirect_to signin_path
      end
    else
      render :action => :new
    end
  end

  def edit
    @user = current_user
    @alerts = current_user.alerts.all(:limit => 1)
    @alerts << Alert.new(:location_id => '1') if @alerts.length < 1
  end

  def update
    @user = current_user

    if @user.update_attributes(params[:user])
      flash[:notice] = "Profile updated!"
      redirect_to edit_profile_path
    else
      @alerts = current_user.alerts.all(:limit => 1)
      @alerts << Alert.new(:location_id => '1') if @alerts.length < 1
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
      if session[:after_registration]
        flash[:notice] += "<a href='#{ENV['WORDPRESS_REGISTERED']}'>Click here</a> to go back to the blog.</a>"
        session.delete(:after_registration)
      end
      redirect_to edit_profile_path
    else
      flash[:error] = "Sorry, could not confirm the email address."
      redirect_to signup_path
    end
  end
end
