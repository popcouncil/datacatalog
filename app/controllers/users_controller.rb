class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create, :confirm]
  before_filter :require_user, :only => [:show, :edit, :update]

  def new
    @user = User.new(:display_name => 'Full name', :email => 'Email')
    @user_session = UserSession.new(:email => 'Email')
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
      @user_session = UserSession.new(:email => 'Email', :password => 'password')
      render :action => :new
    end
  end

  def edit
    @user = current_user
    @alert_user = current_user
    @alert_topics = current_user.alert_topics
    @alert_locations = current_user.alert_locations
  end

  def update
    @user = current_user.dup

    if @user.update_attributes(params[:user])
      flash[:notice] = "Profile updated!"
      redirect_to edit_profile_path
    else
      @alert_user = current_user
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
