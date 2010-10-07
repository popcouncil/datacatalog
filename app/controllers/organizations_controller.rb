class OrganizationsController < ApplicationController
  include BrowseTableSorts

  rescue_from ActiveRecord::RecordNotFound do
    render_404 nil
  end

  def show
    @organization = Organization.find_by_slug(params[:id])
    @data_records = @organization.data_records.sorted(sort_order).paginate(:page => params[:page])
  end
end
