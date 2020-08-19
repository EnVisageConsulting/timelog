class ActivatesController < ApplicationController
  skip_before_action :require_user
  load_resource :user

  def update
    respond_to do |format|
      if @user.activate!
        format.html { redirect_to edit_password_recovery_path(params[:password_recovery]), notice: "#{@user.name} was activated successfully!" }
      else
        format.html { redirect_to login_path, alert: "Unable to activate #{@user.name}." }
      end
    end
  end
end
