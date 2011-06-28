class ContestController < ApplicationController
  before_filter :check_contests, :except => [:index, :update, :admin]
  before_filter :check_user, :only => [:new, :create, :update]
  DEFAULT_CONTEST = {:title => 'Title', :summary => 'Summary', :program_url => 'URL to Program',
    :video_url => 'URL to Video', :photo_url => 'URL to Photos'}.freeze
  
  def index
  end

  def show
  end

  def new
    redirect_to contest_path(params[:id]) unless %w(Software Journalism).include?(params[:category])
    @registration = ContestRegistration.new(:affiliation => (current_user.affiliation.name rescue 'Affiliation'),
      :email => (current_user.email || 'Email'), :phone => (current_user.telephone_number || 'Phone'),
      :address => 'Address', :city => (current_user.city || 'City'), :category => params[:category])
  end

  def create
    contest = params[:contest_registration]
    contest[:members].delete_if { |k| (k[:name] == 'Name' or k[:name].blank?) and (k[:email] == 'Email' or k[:email].blank?)}
    ['email', 'phone', 'city', 'address', 'affiliation'].each { |x| contest[x] = '' if contest[x] == x.capitalize }
    @registration = ContestRegistration.new(params[:contest_registration].merge(:user_id => current_user.id, :contest => params[:id]))
    if @registration.save
      #@entry = ContestEntry.new(DEFAULT_CONTEST)
      Notifier.deliver_contest_registration(@registration)
    else
      render :action => :new
    end
  end

  #This is for later when we allow submissions
  def update
    DEFAULT_CONTEST.each_pair { |k, v| params[:contest_entry][k] = nil if params[:contest_entry][k] == v or params[:contest_entry][k].blank? }
    @registration = ContestRegistration.first(:conditions => {:id => params[:id], :user_id => current_user.id})
    @entry = @registration.contest_entries.new(params[:contest_entry])
    if @entry.save
      #Notifier.deliver_contest_entry(@registration, @entry)
    else
      @entry.defaults(DEFAULT_CONTEST)
      render :action => :create
    end
  end

  def admin
    redirect_to contest_index_path unless current_user.admin?
    @entries = ContestEntry.all(:include => [:contest_registration => :user])
  end

  protected
    def check_contests
      redirect_to contest_index_path unless %w(Senegal Nambia Ghana).include?(params[:id])
    end

    def check_user
      unless current_user
        session[:return_to] = params
        session[:after_registration] = params
        redirect_to signin_path
      end
    end

end
