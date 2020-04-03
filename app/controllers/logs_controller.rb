class LogsController < ApplicationController
  before_action :load_new_log, only: :create
  load_and_authorize_resource param_method: :log_params

  def create
    if current_log
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
      if @log.update_attributes(log_params)
        format.html { redirect_to @log, notice: "Successfully updated log" }
      else
        @log.project_logs.build if @log.project_logs.blank?

        format.html { render :edit }
      end
    end
  end

  def show
    redirect_to edit_log_path(@log) unless @log.activated?
  end

  def destroy
    @log.destroy

    respond_to do |format|
      format.html { redirect_to root_path, notice: "Log cancelled." }
    end
  end

  private

    def load_new_log
      start_at = DateTime.now

      if params[:continue] && ToBoolean(params[:continue])
        last_log = current_user.logs.order('end_at DESC').first
        start_at = last_log.end_at + 1.second if last_log
      end

      @log = Log.new(user: current_user, start_at: start_at)
    end

    def log_params
      params.require(:log).permit(:start_at, :end_at, project_logs_attributes: [:id, :project_id, :percent, :description, :non_billable, :_destroy])
    end
end
