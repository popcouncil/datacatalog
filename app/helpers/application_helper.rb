# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include SortableTable::App::Helpers::ApplicationHelper

  def body_class_hook
    @body_class_hook
  end

  def custom_error_messages
    { :header_message => "", :message => "The following problems occurred:" }
  end

  def active_if(options)
    actions = Array.wrap(options[:action])
    controllers = Array.wrap(options[:controller])

    action_matches = actions.empty? || actions.include?(params[:action])
    controller_matches = controllers.empty? || controllers.include?(params[:controller])
    user_matches = options[:current_user] ? current_user.present? : true

    action_matches && controller_matches && user_matches ? "active" : ""
  end

  def show_flash_message
    message = ""
    flash.each do |name, msg|
      message += content_tag :div, msg, :id => "flash_#{name}"
    end
    message
  end

  def detail_field(obj, options)
    if options[:collection]
      return nil if obj.send(options[:attribute]).empty?
    else
      return nil if obj.send(options[:attribute]).blank?
    end

    dd_content = if options[:url]
      link_to(options[:value], options[:url])
    elsif options[:titleize]
      options[:value].titleize
    elsif options[:collection]
      options[:value].join(", ")
    else
      options[:value]
    end

    output = content_tag(:dt, (options[:label] || options[:attribute].to_s.humanize)) +
      content_tag(:dd, dd_content) +
      (options[:noclear] && !@clear ? "" : content_tag(:div, "", :class => 'clear'))
    @clear = !@clear
    output
  end

  def gravatar_for(user, options={})
    options.reverse_merge!(:class => "avatar", :size => 64)
    gravatar_image_tag(user[:email],
      :alt      => user.display_name,
      :title    => user.display_name,
      :class    => options[:class],
      :width    => options[:size],
      :height   => options[:size],
      :gravatar => { :size => options[:size] }
    )
  end

  def markdownize(text)
    RDiscount.new(text).to_html
  end

  def markdown_instructions
    url = "http://www.squarespace.com/display/ShowHelp?section=Markdown"
    %(Use <a href="#{url}" target="_blank">Markdown</a> for formatting.)
  end

  def star_class(rating)
    case rating
    when 1 then "ratedOneStar"
    when 2 then "ratedTwoStars"
    when 3 then "ratedThreeStars"
    when 4 then "ratedFourStars"
    when 5 then "ratedFiveStars"
    else ""
    end
  end
end
