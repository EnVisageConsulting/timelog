class ProjectsController < ApplicationController
  before_action :require_admin
  load_and_authorize_resource param_method: :project_params

  def index
  end

  def new
  end

  def create
    respond_to do |format|
      if @project.save
        format.html { redirect_to projects_path, notice: "Succesfully created new project!" }
      else
        format.html { render :new }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to projects_path, notice: "Successfully updated project!" }
      else
        format.html { render :edit }
      end
    end
  end

  private

    def project_params
      params.require(:project).permit(:name, :deactivated)
    end
end
