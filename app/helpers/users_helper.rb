module UsersHelper
  def user_role(user)
    user.try(:api_user).try(:role).try(:to_sym)
  end
end
