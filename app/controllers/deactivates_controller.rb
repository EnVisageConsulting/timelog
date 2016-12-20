class DeactivatesController < ApplicationController
  before_action :require_admin
  load_and_authorize_resource :user
  require 'to_boolean'

  def update
    raise NOT_FOUND unless params[:deactivate]

    respond_to do |format|
      if @user.deactivate! deactivating?
        format.html { redirect_to users_path(deactivated: !deactivating?), notice: "#{@user.name} was #{'de' if deactivating?}activated successfully!" }
      else
        format.html { redirect_to users_path(deactivated: !deactivating?), alert: "Unable to #{'de' if deactivating?}activate #{@user.name}." }
      end
    end
  end

  private

    def deactivating?
      @deactivating ||= ToBoolean(params[:deactivate])
    end
end
