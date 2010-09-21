module UserRoles
  def normalize_role(string)
    case string
      when "user";          "basic"
      when "ministry user"; "ministry_user"
      when "admin";         "admin"
    end
  end
end

World(UserRoles)
