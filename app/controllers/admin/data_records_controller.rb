class Admin::DataRecordsController < AdminController
  def index
    @data_records = DataRecord.paginate(:page => params[:page])
  end
end
