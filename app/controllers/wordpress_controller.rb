class WordpressController < ApplicationController
  def callback
    render :text => '' and return if !['save', 'destroy', 'login', 'logout'].include?(params['callback'])
    @wpdata = User.from_wpdata(params['payload']) if params[:payload]
    if @wpdata.is_a?(Hash)
      @user = User.find_or_initialize_by_id(@wpdata['ID'])
      self.send(params[:callback])
    elsif params[:callback] == 'logout'
      logout
    end
    render :text => ''
  end

  protected
    def destroy
      @user.destroy unless @user.new?
    end

    def save
      @user.email = @wpdata['user_email']
      @user.display_name = @wpdata['display_name']
      @user.personal_url = @wpdata['user_url']
#      if @wpdata['user_pass']
#        @user.password = @wpdata['user_pass']
#        @user.password_confirmation = @wpdata['user_pass']
#      end
      @user.save
    end

    def login
      if @wpdata['time'] < Time.now.to_i + 300 and @wpdata['time'] > Time.now.to_i - 300
        @user_session = UserSession.new(@user)
        @user_session.save
      end
    end

    def logout
      current_user_session.destroy if current_user_session
    end
end
