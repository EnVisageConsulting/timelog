class ReportsController < ApplicationController
  before_action :require_admin_or_partner

  def index
  end
end
