class TagsController < ApplicationController
  before_action :require_admin
  load_and_authorize_resource param_method: :tag_params

  def index
  end

  def new
  end

  def create
    respond_to do |format|
      if @tag.save
        format.html { redirect_to projects_path, notice: "Succesfully created new project tag!" }
      else
        format.html { render :new }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @tag.update_attributes(tag_params)
        format.html { redirect_to projects_path, notice: "Successfully updated project tag!" }
      else
        format.html { render :edit }
      end
    end
  end

  private

    def tag_params
      params.require(:tag).permit(:name, :deactivated)
    end
end
