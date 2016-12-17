class UsersController < ApplicationController
  before_action :require_admin, only: [:index, :edit, :update]
  load_and_authorize_resource param_method: :user_params

  def new
  end

  def create
    respond_to do |format|
      if @user.save
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
      if @user.update_attributes(user_params)
        format.html { redirect_to users_path, notice: "Successfully updated #{@user.name}!" }
      else
        format.html { render :edit }
      end
    end
  end

  def show
    @logs = user_logs.page(pagination_page).per(per_page)
  end

  private

    def user_params
      permitted = [:first, :last]
      permitted.push(:email) if params[:action] == 'create'
      permitted.push(:role)  if current_user.admin?

      params.require(:user).permit(permitted)
    end

    def user_logs
      @user_logs ||= @user.logs.active.latest
    end

    def per_page
      # return 5 # uncomment for testing with smaller groups
      Kaminari.config.default_per_page
    end

    def page_from_date(date)
      records_from_date = user_logs.where('start_at >= ?', date).count.to_f

      ( records_from_date / per_page ).ceil
    end

    def pagination_page
      if params[:date].is_a?(String) && params[:date].match(DATE_PATTERN)
        date = DateTimeParser.string_to_datetime(params[:date])

        # jump to page using supplied date
        return page_from_date(date)
      end

      params[:page]
    end
end
