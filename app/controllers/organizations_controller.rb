class OrganizationsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound do
    render_404 nil
  end

  def show
    @organization = Organization.find_by_slug(params[:id])
    @data_records = @organization.data_records.paginate(:page => params[:page])
  end
end
