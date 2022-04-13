class SettingsController < ApplicationController
  def index
  end

  def update
    respond_to do |format|
      if current_user.update(settings_params)
        format.html { redirect_to settings_path, notice: "Successfully updated settings!" }
      else
        format.html { render :index }
      end
    end
  end

  private

    def settings_params
      params.require(:user).permit(:email)
    end
end
