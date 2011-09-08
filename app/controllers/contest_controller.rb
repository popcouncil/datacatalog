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
      :email => (current_user.email || 'Email'), :phone => (current_user.telephone_number || 'Phone / Téléphone'),
      :address => 'Address / Adresse', :city => (current_user.city || 'City / La Ville'), :category => params[:category])
  end

  def create
    contest = params[:contest_registration]
    contest[:members].delete_if { |k| (k[:name] == 'Name' or k[:name].blank?) and (k[:email] == 'Email' or k[:email].blank?)}
    contest[:phone] = '' if contest[:phone] == 'Phone / Téléphone'
    contest[:city] = '' if contest[:city] == 'City / La Ville'
    contest[:address] = '' if contest[:address] == 'Address / Adresse'
    ['email', 'phone', 'city', 'address', 'affiliation'].each { |x| contest[x] = '' if contest[x] == x.capitalize }
    @registration = ContestRegistration.new(params[:contest_registration].merge(:user_id => current_user.id, :contest => params[:id]))
    if @registration.save
      #@entry = ContestEntry.new(DEFAULT_CONTEST)
      Notifier.deliver_contest_registration(@registration)
      flash[:notice] = 'Successfully joined the contest. You will receive a an email confirmation shortly.'
      redirect_to contest_index_path
    else
      @registration.defaults(:affiliation => (current_user.affiliation.name rescue 'Affiliation'),
      :email => (current_user.email || 'Email'), :phone => (current_user.telephone_number || 'Phone'),
      :address => 'Address', :city => (current_user.city || 'City'), :category => params[:category])
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
    redirect_to contest_index_path and return unless current_user.admin?
    @registrations = ContestRegistration.all(:include => [:contest_entry, :user])
    respond_to do |f|
      f.html {}
      f.csv {
        require 'csv'
        csv = ''
        CSV::Writer.generate(csv) do |c|
          c << ['Contest', 'Category', 'Members', 'Affiliation', 'Emails', 'Phone', 'Address', 'City', 'Title', 'Summary', 'Program URL', 'Video URL', 'Photo URL', 'File', 'Register Time', 'Entry Time']
          @registrations.each do |reg|
            entry = reg.contest_entry
            user = reg.user
            c << [reg.contest, reg.category, reg.friendly_members.join("\n"), reg.affiliation, reg.email, reg.phone, reg.address, reg.city, (entry.title rescue nil), (entry.summary rescue nil), (entry.program_url rescue nil), (entry.video_url rescue nil), (entry.photo_url rescue nil), (entry.file_file_name rescue nil), (reg.created_at.strftime('%c %z') rescue nil), (entry.created_at.strftime('%c %z') rescue nil)]
          end
        end
        send_data csv, :type => 'text/csv; charset=iso-8859-1; header=present',
          :disposition => "attachment; filename=admin_#{Time.now.strftime('%Y-%m-%d')}.csv"
      }
    end
  end

  protected
    def check_contests
      redirect_to contest_index_path unless %w(Senegal Namibia Ghana).include?(params[:id])
    end

    def check_user
      unless current_user
        session[:return_to] = params
        session[:after_registration] = params
        redirect_to signin_path
      end
    end

end
