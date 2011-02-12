class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
  before_filter :activate_authlogic

  def new
    redirect_to signup_path
  end

  def create
    @user_session = UserSession.new params[:user_session]

    if @user_session.save
      flash[:notice] = "You have been signed in."
      @user_session.user.call_wordpress = true
      @user_session.user.password = params[:user_session][:password]
      @user_session.user.save_wordpress
      #Would be cleaner as a script tag, however, wordpress doesn't like returning a blank page
      flash[:login_callback] = "<iframe height=0 width=0 frameborder=0 src='#{(ENV['WORDPRESS_URL'] || '')}?callback=login&payload=#{CGI.escape(@user_session.user.wpdata(true).gsub("\n", ''))}'></iframe>"
      redirect_to session.delete(:return_to) || data_records_path
    else
    @user = User.new(:display_name => 'Full name', :email => 'Email', :password => 'password', :password_confirmation => 'confirmation')
      render :action => "new" and return
    end
  end

  def update
    create
  end

  def destroy
    @user = current_user
    current_user_session.destroy
    flash[:notice] = "You have been signed out."
    flash[:logout_callback] = "<iframe height=0 width=0 frameborder=0 src='#{(ENV['WORDPRESS_URL'] || '')}?callback=logout'></iframe>"
    redirect_to root_url
  end

end
