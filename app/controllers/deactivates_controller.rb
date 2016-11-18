class DeactivatesController < ApplicationController
  before_action :require_admin
  load_and_authorize_resource :user

  def update
    raise NOT_FOUND unless params[:deactivate]

    respond_to do |format|
      if @user.deactivate! deactivating?
        format.html { redirect_to users_path(deactivated: !deactivating?), notice: "#{@user.name} was deactivated successfully!" }
      else
        format.html { redirect_to users_path(deactivated: !deactivating?), alert: "Unable to deactivate #{@user.name}." }
      end
    end
  end

  private

    def deactivating?
      @deactivating ||= ToBoolean(params[:deactivate])
    end
end
