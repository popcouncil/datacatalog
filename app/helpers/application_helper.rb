# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def custom_error_messages
    { :header_message => "", :message => "The following problems occurred:" }
  end
  
  def active_if(options)
    if options[:action]
      options[:action].each do |action|
        return "active" if params[:action] == action
      end
    elsif options[:controller]
      options[:controller].each do |controller|
        return "active" if params[:controller] == controller
      end
    else
      ""
    end
  end
  
  def show_flash_message
    message = ""
    flash.each do |name, msg|
      message += content_tag :div, msg, :id => "flash_#{name}"
    end
    message
  end

end
