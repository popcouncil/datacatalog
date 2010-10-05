module NavigationHelpers

  def path_to(page_name)
    case page_name

    when /the homepage/
      '/'
    when /sign up/
      '/signup'
    when /sign in/, "the sign in page"
      '/signin'
    when /sign out/
      '/signout'
    when /my profile/
      edit_profile_path
    when /the contact form/
      '/contact'
    when 'my dashboard'
      dashboard_path
    when 'the admin dashboard'
      admin_data_records_path
    when "the data record's page"
      data_record_path(the.data_record || DataRecord.first)
    when "the browse page"
      data_records_path

    # Add more mappings here.
    # Here is a more fancy example:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
