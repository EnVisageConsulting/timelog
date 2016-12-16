class UsersController < ApplicationController
  before_action :require_admin, only: [:index, :edit, :update, :show]
  load_and_authorize_resource param_method: :user_params

  def new
  end

  def create
    respond_to do |format|
      if @user.save
        format.html { redirect_to root_path, notice: "Successfully added employee!" }
      else
        format.html { render :new }
      end
    end
  end

  def index
  end

  def edit
  end

  def update
    respond_to do |format|
      if @user.update_attributes(user_params)
        format.html { redirect_to users_path, notice: "Successfully updated #{@user.name}!" }
      else
        format.html { render :edit }
      end
    end
  end

  def show
  end

  private

    def user_params
      permitted = [:first, :last]
      permitted.push(:email) if params[:action] == 'create'
      permitted.push(:role)  if current_user.admin?

      params.require(:user).permit(permitted)
    end
end
