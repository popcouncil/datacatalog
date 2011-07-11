module UsersHelper
  def user_role(user)
    user.role.to_sym
  end

  def owners_for_select(default)
    [["Myself", { default.display_name => default.id }],
     ["Ministry Users", User.ministry_users.map {|user| [user.display_name, user.id] }]]
  end

  def ministries_for_select
    ["All", "-------------"] + User.ministry_users.map {|u| [u.display_name, u.id.to_s] }
  end
  
  def organization_tree_except(org)
    nested_set_options(Organization, org) {|i| "#{'-' * i.level} #{i.name}" }
  end

  def ministries_and_organizations_for_select(selected = nil)
    regular_options = options_for_select(["All", "-------------"], :disabled => "-------------")
    grouped_options = {"" =>  User.ministry_users.map {|u| [u.display_name, "ministry-#{u.id.to_s}"] }}
    grouped_options[""] |= organization_tree_except(nil).map { |name, id| [name, "organization-#{id.to_s}"] }
    grouped_options[''].sort! { |x, y| x.first <=> y.first }
    grouped_options = grouped_options_for_select(grouped_options, :selected => selected)
    "#{regular_options}#{grouped_options}" 
  end
end
