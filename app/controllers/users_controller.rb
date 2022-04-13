class UsersController < ApplicationController
  before_action :require_admin, only: [:index, :edit, :update]
  load_and_authorize_resource param_method: :user_params

  def new
  end

  def create
    respond_to do |format|
      if @user.save
        @password_recovery = PasswordRecovery.create(user: @user)
        UserMailer.new_user_email(@user).deliver_later
        UserMailer.user_activation_email(@user, @password_recovery).deliver_later
        format.html { redirect_to root_path, notice: "Successfully added employee!" }
      else
        format.html { render :new }
      end
    end
  end

  def index
  end

  def edit
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_path, notice: "Successfully updated #{@user.name}!" }
      else
        format.html { render :edit }
      end
    end
  end

  def show
    @user ||= User.find(params[:id])
    @logs = user_logs.page(params[:page]).per(Kaminari.config.default_per_page)
  end

  private

    def user_params
      permitted = [:first, :last, :email]
      permitted.push(:role)  if current_user.admin?

      params.require(:user).permit(permitted)
    end

    def user_logs
      filter_by_date
      filter_by_project
      @user_logs.order("start_at DESC")
    end

    def filter_by_project
      return unless params[:project_ids].present?

      project_ids = params[:project_ids].map{|p| p.to_i}
      @user_logs = @user_logs.joins(:project_logs).where(project_logs: {project_id: project_ids})
    end

    def filter_by_date
      start_date = DateTime.strptime(params[:start_date], '%m/%d/%Y').beginning_of_day if params[:start_date].present?
      end_date = DateTime.strptime(params[:end_date], '%m/%d/%Y').end_of_day if params[:end_date].present?
      if start_date.present? && end_date.present?
        @user_logs = @user.logs.where("start_at >= ? AND end_at <= ?", start_date, end_date)
      elsif start_date.present?
        @user_logs = @user.logs.where("start_at >= ?", start_date)
      elsif end_date.present?
        @user_logs = @user.logs.where("end_at <= ?", end_date)
      else
        @user_logs ||= @user.logs.latest
      end
    end
end
