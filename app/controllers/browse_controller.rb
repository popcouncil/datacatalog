class BrowseController < ApplicationController
  def index
    @data_records = DataRecord.paginate(:page => params[:page])
  end
end
