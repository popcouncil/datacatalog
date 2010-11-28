class DataRecordsController < ApplicationController
  before_filter :require_user, :only => [:new, :create]
  before_filter :find_data_record, :only => [:show, :edit, :update]
  before_filter :require_owner_or_admin, :only => [:edit, :update]
  before_filter :format_ministry_organization_params, :only => [:index]

  include BrowseTableSorts

  def index
    @filters = Filters.new(params[:filters])
    @data_records = DataRecord.browse(@filters, sort_order).paginate(:page => params[:page], :per_page => 25)
  end

  def show
    @comments = @data_record.root_comments
    @comment = @data_record.comment_threads.new(
      :reports_problem => params.has_key?(:reports_problem),
      :parent_id       => params[:parent_id]
    )
  end
  
  def new
    @data_record = current_user.data_records.new
    initialize_data_record_associations
  end

  def create
    @data_record = DataRecord.new(params[:data_record])

    if current_user.admin?
      @data_record.owner_id = params[:data_record][:owner_id]
    else
      @data_record.owner_id = current_user.id
    end

    if @data_record.save
      flash[:notice] = "Your Data has been submitted"
      redirect_to @data_record
    else
      initialize_data_record_associations
      render :new
    end
  end

  def edit
    initialize_data_record_associations
  end

  def update
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
    @data_record.data_record_locations.build(:location_id => Location.global.id) if @data_record.locations.empty?
    @data_record.authors.unshift Author.new(:affiliation_name => @data_record.lead_organization_name)
    @data_record.build_contact_from_owner if @data_record.contact.blank?
  end

  def find_data_record
    @data_record = DataRecord.find_by_slug(params[:id], :include => [:organizations, :locations, :authors, :contact, :tags, :comment_threads, :ratings, :favorites])
  end
  
  def format_ministry_organization_params
    if params[:filters].present? && params[:filters][:ministry_organization].present?
      if params[:filters][:ministry_organization].present?
        kind, id = params[:filters][:ministry_organization].split("-")
        params[:filters][kind.to_sym] = id
      else
        params[:filters][:ministry] = "All"
        params[:filters][:organization] = "All"
      end
    end
  end

  def require_owner_or_admin
    unless current_user == @data_record.owner || current_user.admin?
      flash[:notice] = "You don't have permission to do that"
      redirect_to @data_record
    end
  end
end
