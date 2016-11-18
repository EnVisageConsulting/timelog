module ProjectsHelper
  def project_list
    if viewing_deactivated?
      Project.inactive.alphabetized
    else
      Project.active.alphabetized
    end
  end
end
