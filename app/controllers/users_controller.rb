class UsersController < ApplicationController
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

  private

    def user_params
      permitted = [:first, :last, :email]
      permitted.push(:role) if current_user.admin?

      params.require(:user).permit(permitted)
    end
end
