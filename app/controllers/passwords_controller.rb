class PasswordsController < ApplicationController
  load_and_authorize_resource :user

  def edit
  end

  def update
    respond_to do |format|
      if @user.update_password(password_params)
        format.html { redirect_to settings_path, notice: "Successfully updated password!" }
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
