module ProjectsHelper
  def project_list
    if viewing_deactivated?
      Project.inactive.alphabetized
    else
      Project.active.alphabetized
    end
  end

  def tag_list
    if viewing_deactivated?
      Tag.inactive.alphabetized
    else
      Tag.active.alphabetized
    end
  end
end
