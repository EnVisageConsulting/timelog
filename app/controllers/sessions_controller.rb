class SessionsController < ApplicationController
  def new
  end

  def create
    employee = User.where(id: params[:employee_id]).undeactivated.activated.first

    respond_to do |format|
      if employee && employee.authenticate(params[:password])
        self.current_user = employee
        format.html { redirect_to root_path, notice: "Successfully logged in!" }
      else
        flash.now[:alert] = "Invalid login credentials."
        format.html { render :new }
      end
    end
  end

  def destroy
    self.current_user = nil

    respond_to do |format|
      format.html { redirect_to login_path, notice: "Successfully logged out!"}
    end
  end
end
