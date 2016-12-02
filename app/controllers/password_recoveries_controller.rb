class PasswordRecoveriesController < ApplicationController
  load_resource find_by: :token, param_method: :password_recovery_create_params

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
  end

  def update
  end

  private

    def password_recovery_create_params
      params.require(:password_recovery).permit(:email)
    end
end
