class Admin::OrganizationsController < AdminController
  def index
    @organizations = Organization.paginate(:page => params[:page])
  end

  def show
    @organization = Organization.find_by_slug(params[:id])
  end

  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.new(params[:organization])

    if @organization.save
      flash[:notice] = "Organization created!"
      redirect_to admin_organization_path(@organization)
    else
      render :new
    end
  end

  def update
    @organization = Organization.find_by_slug(params[:id])
    
    if @organization.update_attributes(params[:organization])
      flash[:notice] = "Organization saved!"
      redirect_to admin_organization_path(@organization)
    else
      render :show
    end
  end
end
