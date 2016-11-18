module UsersHelper
  def user_list
    viewing_deactivated? ? @users.deactivated : @users.undeactivated
  end
end
