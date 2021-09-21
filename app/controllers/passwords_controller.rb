class PasswordsController < ApplicationController
  load_and_authorize_resource :user

  def edit
  end

  def update
    respond_to do |format|
      if @user.update_password(password_params, current_user)
        path = current_user.admin? ? users_path : settings_path
        format.html { redirect_to path, notice: "Successfully updated password!" }
      else
        format.html { render :edit }
      end
    end
  end

  private

    def password_params
      params.require(:password).permit(:new, :current, :confirmation)
    end
end
