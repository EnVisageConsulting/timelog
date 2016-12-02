class PasswordRecoveriesController < ApplicationController
  load_resource find_by: :token, param_method: :password_recovery_params

  def new
  end

  def create
    respond_to do |format|
      if @password_recovery.save
        format.html { redirect_to login_path, notice: "Success! Check your email inbox for a password reset link." }
      else
        format.html { render :new }
      end
    end
  end

  def edit
    @user = @password_recovery.user
  end

  def update
    @user = @password_recovery.user

    respond_to do |format|
      if @user.update_attributes(user_params)
        format.html { redirect_to login_path, notice: "Successfully updated password!" }
      else
        format.html { render :edit }
      end
    end
  end

  private

    def password_recovery_params
      params.require(:password_recovery).permit(:email)
    end

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end
end
