class ProjectsController < ApplicationController
  load_and_authorize_resource param_method: :project_params

  def index
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  private

    def project_params
      params.require(:project).permit(:name)
    end
end
