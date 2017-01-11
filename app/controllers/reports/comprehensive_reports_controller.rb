class Reports::ComprehensiveReportsController < ApplicationController
  def index
  	@comprehensive_report = Reports::ComprehensiveReport.new
  end
end
