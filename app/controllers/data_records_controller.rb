class DataRecordsController < ApplicationController
  before_filter :require_user, :only => [:new, :create]
  before_filter :find_data_record, :only => [:show, :edit, :update]
  before_filter :require_owner_or_admin, :only => [:edit, :update]
  before_filter :format_ministry_organization_params, :only => [:index]
  before_filter :tag_list, :only => [:update, :create]

  include BrowseTableSorts

  def index
    @filters = Filters.new(params[:filters])
    @data_records = DataRecord.browse(@filters, sort_order).paginate(:page => params[:page], :per_page => 25)
  end

  def show
    @data_record.views_count += 1
    @data_record.save
    @comments = @data_record.root_comments
    @comment = @data_record.comment_threads.new(
      :reports_problem => params.has_key?(:reports_problem),
      :parent_id       => params[:parent_id]
    )
  end
  
  def new
    @data_record = current_user.data_records.new(:title => 'Title', :description => 'Add description')
    initialize_data_record_associations
  end

  def create
    params[:data_record][:documents_attributes].delete('0') if params[:data_record][:documents_attributes]
    params[:data_record][:authors_attributes].delete('0') if params[:data_record][:authors_attributes]
    if params[:id].present?
      @data_record = DataRecord.unscoped_find(:first, :conditions => {:slug => params[:id]})
    else
      @data_record = DataRecord.new(params[:data_record])
    end

    if @data_record.owner_id.blank?
      if current_user.admin?
        @data_record.owner_id = params[:data_record][:owner_id]
      else
        @data_record.owner_id = current_user.id
      end
    end

    if (@data_record.new_record? ? @data_record.save : @data_record.update_attributes(params[:data_record]) )
      if @data_record.completed?
        flash[:notice] = "Your Data has been submitted"
        redirect_to @data_record and return
      else
        @data_record.next_step
        @data_record.lead_organization_name = 'Lead organization'
        @data_record.collaborator_list= 'Other institutional collaborators'
        @data_record.homepage_url = 'URL'
        @data_record.funder = 'Funder'
      end
    end
    initialize_data_record_associations
    render :new
  end

  def edit
    initialize_data_record_associations
  end

  def update
    params[:data_record][:documents_attributes].delete('0') if params[:data_record][:documents_attributes]
    params[:data_record][:authors_attributes].delete('0') if params[:data_record][:authors_attributes]
    if current_user.admin?
      @data_record.owner_id = params[:data_record][:owner_id]
    else
      @data_record.owner_id = current_user.id
    end

    if @data_record.update_attributes(params[:data_record])
      flash[:notice] = "Your Data has been updated"
      redirect_to @data_record
    else
      initialize_data_record_associations
      render :edit
    end
  end

  private

  def initialize_data_record_associations
    @data_record.documents.build if @data_record.documents.empty?
    @data_record.data_record_locations.build(:location_id => 0) if @data_record.locations.empty?
    @data_record.authors.unshift Author.new(:affiliation_name => @data_record.lead_organization_name, :name => 'Author')
    @data_record.build_contact_from_owner if @data_record.contact.blank?
  end

  def find_data_record
    @data_record = DataRecord.find_by_slug(params[:id], :include => [:organizations, :locations, :authors, :contact, :tags, :comment_threads, :ratings, :favorites])
  end
  
  def format_ministry_organization_params
    if params[:filters].present? && params[:filters][:ministry_organization].present?
      kind, id = params[:filters][:ministry_organization].split("-")
      params[:filters][kind.to_sym] = id
    end
  end

  def require_owner_or_admin
    unless current_user == @data_record.owner || current_user.admin?
      flash[:notice] = "You don't have permission to do that"
      redirect_to @data_record
    end
  end

  def tag_list # Alert! This method of generating the tag list allows arbitrary tags to slip in if the user tampers with the input
    if params[:tags]
      params[:data_record][:tag_list] = params[:tags].uniq
      params[:data_record][:tag_list].delete('Select Tag')
      params[:data_record][:tag_list] = params[:data_record][:tag_list].flatten.join(',').split(',').uniq.join(',')
    end
    if params[:data_record] and params[:data_record][:data_record_locations_attributes]
      params[:data_record][:data_record_locations_attributes].delete_if { |x| x[1][:location_id] == '0' }
    end
  end
end
