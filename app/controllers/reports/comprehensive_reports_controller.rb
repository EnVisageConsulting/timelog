class Reports::ComprehensiveReportsController < ApplicationController
  def index
  	@comprehensive_report = Reports::ComprehensiveReport.new
  end

  def create
    @comprehensive_report = Reports::ComprehensiveReport.new

    respond_to do |format|
      if @comprehensive_report.valid?
        format.html { redirect_to reports_comprehensive_reports_path }
      else
        format.html { render :new }
      end
    end
  end

end
