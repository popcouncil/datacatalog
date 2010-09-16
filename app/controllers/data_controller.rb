class DataController < ApplicationController
  before_filter :require_user, :except => [:show, :docs, :show_doc, :usages]
  before_filter :set_source, :set_favorite, :except => [:new, :create]

  def comment
    comment = params[:data_catalog_comment]
    DataCatalog.with_key(current_user.api_key) do
      api_params = { :source_id => @data_record.id, :text => comment[:text] }
      [:parent_id, :reports_problem].each do |field|
        api_params[field] = comment[field]  if comment[field] && !comment[field].blank?
      end
      DataCatalog::Comment.create(api_params)
    end
    flash[:notice] = "Comment saved!"
    redirect_to @data_record
  end

  def comment_rating
    DataCatalog.with_key(current_user.api_key) do
      DataCatalog::Rating.create(:kind => "comment", :comment_id => params[:comment_id], :value => 1)
    end
    flash[:notice] = "Comment rating saved!"
    redirect_to source_path(@source.slug)
  end

  def docs
    @docs = DataCatalog::Document.all(:source_id => @source.id)
    @doc = @docs.first
    @docs.each do |doc|
      doc.user = User.find_by_api_id(doc.user_id)
    end
  end

  def show_doc
    @docs = DataCatalog::Document.all(:source_id => @source.id)
    @doc = DataCatalog::Document.get(params[:id])
    @docs.each do |doc|
      doc.user = User.find_by_api_id(doc.user_id)
    end
    render 'docs'
  end

  def edit_docs
    @docs = DataCatalog::Document.all(:source_id => @source.id)
    @doc = @docs.first
    @docs.each do |doc|
      doc.user = User.find_by_api_id(doc.user_id)
    end
    if @doc.nil?
      @doc = DataCatalog::Document.new
      @doc.is_new = true
    end
    @doc
  end

  def create_doc
    DataCatalog.with_key(current_user.api_key) do
      @document = DataCatalog::Document.create(:source_id => @source.id, :text => params[:data_catalog_document][:text])
    end
    flash[:notice] = "Updated documentation."
    redirect_to source_docs_path(@source.slug)
  end

  def update_doc
    DataCatalog.with_key(current_user.api_key) do
      @document = DataCatalog::Document.update(params[:id], :text => params[:data_catalog_document][:text])
    end
    flash[:notice] = "Updated documentation."
    redirect_to source_docs_path(@source.slug)
  end

  private

  def find_parent_comment(comments, parent_id)
    comments.each do |comment|
      return comment if comment.id == parent_id
    end

    parent = nil
    comments.each do |comment|
      parent = find_parent_comment(comment.children, parent_id)
    end
    return parent
  end

  def set_source
    @source = DataCatalog::Source.first(:slug => params[:slug])
    render_404(nil) unless @source
  end

  def set_favorite
    @is_favorite = false
    if current_user
      current_user.api_user.favorites.each do |source|
        @is_favorite = true if source.slug == params[:slug]
      end
    end
  end

end
