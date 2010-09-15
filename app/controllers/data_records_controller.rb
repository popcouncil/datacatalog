class DataRecordsController < ApplicationController
  before_filter :initialize_data_record, :only => :new

  def show
    @data_record = DataRecord.find_by_slug(params[:id])
    @comments = @data_record.comments
    @comment = DataCatalog::Comment.new
  end
  
  def new
    @organizations = DataCatalog::Organization.all
  end

  def create
    @organizations = DataCatalog::Organization.all
    @data_record = DataRecord.new(params[:data_record])

    if @data_record.save
      flash[:notice] = "Your Data has been submitted"
      redirect_to @data_record
    else
      @data_record.build_author  if @data_record.author.blank?
      @data_record.build_contact if @data_record.contact.blank?
      @data_record.build_catalog if @data_record.catalog.blank?
      render :new
    end
  end

  def initialize_data_record
    @data_record = DataRecord.new
    @data_record.build_author
    @data_record.build_contact
    @data_record.build_catalog
  end
end
