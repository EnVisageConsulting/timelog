module UsersHelper
  def user_list
    viewing_deactivated? ? @users.deactivated : @users.undeactivated
  end

  def project_in_user_log?(project_ids, project_log)
    project_ids.present? && project_ids.include?(project_log.project_id.to_s)
  end

  def partner_project_options_for(user)
    projects = Project.active
    projects |= user.partner_projects

    options_from_collection_for_select(projects, :id, :name, user.partner_project_ids)
  end

  def partner_tag_options_for(user)
    tags = Tag.active
    tags |= user.partner_tags

    options_from_collection_for_select(tags, :id, :name, user.partner_tag_ids)
  end
end
