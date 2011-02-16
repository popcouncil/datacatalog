class MainController < ApplicationController

  include BrowseTableSorts

  def index
    @source_count = DataRecord.count
    @top = DataRecord.all(:limit => 3, :order => 'id DESC')
    render 'welcome'
  end

  def dashboard
    if current_user
      render 'dashboard'
    else
      redirect_to root_path
    end
  end

  def about

  end

  def blog
    require 'feedzirra'
    url = "http://sunlightlabs.com/blog/feeds/tag/datacatalog/" #natdatcat or data.gov
    feed = Feedzirra::Feed.fetch_and_parse(url)
    @entries = feed.entries
  end
end
