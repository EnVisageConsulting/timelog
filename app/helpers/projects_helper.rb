module ProjectsHelper
  def project_list
    if params[:deactivated] == 'true'
      Project.inactive.alphabetized
    else
      Project.active.alphabetized
    end
  end

  def viewing_deactivated?
    params[:deactivated] == 'true'
  end
end
