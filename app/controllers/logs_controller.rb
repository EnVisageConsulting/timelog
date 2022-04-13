class LogsController < ApplicationController
  before_action :load_new_log, only: :create
  skip_load_resource only: :create
  load_and_authorize_resource param_method: :log_params
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  def create
    if @log.user == current_user && current_log
      flash[:alert] = "You have an active log that needs to be completed first."
      return redirect_to edit_log_path(current_log)
    end

    respond_to do |format|
      if @log.save
        format.html { redirect_to edit_log_path(@log) }
      else
        format.html { render :new }
      end
    end
  end

  def edit
    @log.project_logs.build if @log.project_logs.blank?
  end

  def update
    respond_to do |format|
      if @log.update(log_params)
        if params[:commit] == "Save and Start a New Log"
          if load_new_log
            if @log.save
              format.html { redirect_to edit_log_path(@log), notice: "Successfully updated log" }
            end
          else
            format.html { redirect_to @log, alert: "Cannot start a new log until this log is finished" }
          end
        else
          format.html { redirect_to @log, notice: "Successfully updated log" }
        end
      else
        @log.project_logs.build if @log.project_logs.blank?

        format.html { render :edit }
      end
    end
  end

  def show
    if @log.activated?
      user = User.find(@log.user_id)
      user_logs = user.logs.active.latest.reverse
      @next_log = user_logs[user_logs.index(@log)+1] if user_logs.index(@log)+1 < user_logs.size
      @prev_log = user_logs[user_logs.index(@log)-1] if user_logs.index(@log)-1 >= 0
    else
      redirect_to edit_log_path(@log)
    end
  end

  def destroy
    @log.destroy

    respond_to do |format|
      format.html { redirect_back fallback_location: root_path }
      flash[:notice] = "Log Successfully Deleted"
    end

  end

  private

    def load_new_log
      start_at = DateTime.now
      user = current_user

      if continuing?
        last_log = current_user.logs.order('end_at DESC').first
        if last_log.end_at?
          start_at = last_log.end_at + 1.second if last_log
        else
          return false
        end
      elsif params[:user].present? && user.admin?
        user = User.find(params[:user])
      end

      @log = Log.new(user: user, start_at: start_at)
    end

    def continuing?
      if (params[:continue] && ToBoolean(params[:continue])) || params[:commit] == "Save and Start a New Log"
        return true
      end
    end

    def log_params
      params.require(:log).permit(:start_at, :end_at, project_logs_attributes: [:id, :project_id, :percent, :description, :non_billable, :_destroy, project_tags: []])
    end

    def record_not_found
      redirect_to root_path, notice: "Log Successfully Deleted"
    end
end
