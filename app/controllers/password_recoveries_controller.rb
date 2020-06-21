class PasswordRecoveriesController < ApplicationController
  load_resource find_by: :token, param_method: :password_recovery_params
  before_action :check_recovery_expiration, only: [:edit, :update]

  skip_before_action :require_user

  def index
    redirect_to edit_password_recovery_path(params[:password_recovery_params])
  end

  def new
  end

  def create
    respond_to do |format|
      if @password_recovery.save
        PasswordRecoveryMailer.password_reset_email(@password_recovery).deliver_later
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
      if user_params[:password].blank?
        @user.errors.add(:password, "is required")

        format.html { render :edit }
      elsif @user.update_attributes(user_params)
        @password_recovery.expire!

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

    def check_recovery_expiration
      if @password_recovery && @password_recovery.expired?
        return redirect_to new_password_recovery_path, alert: "That link has expired. Please request a new one."
      end
    end
end
