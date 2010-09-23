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
end
