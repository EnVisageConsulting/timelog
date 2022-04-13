module ProjectsHelper
  def project_list
    viewing_deactivated? ? Project.inactive : Project.active
  end

  def tag_list
    viewing_deactivated? ? Tag.inactive : Tag.active
  end
end
