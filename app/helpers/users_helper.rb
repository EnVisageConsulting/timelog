module UsersHelper
  def user_list
    viewing_deactivated? ? @users.deactivated : @users.undeactivated
  end

  def project_in_user_log?(project_ids, project_log)
    project_ids.present? && project_ids.include?(project_log.project_id.to_s)
  end
end
