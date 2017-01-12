class Reports::ComprehensiveReportsController < ApplicationController
  def create
    @comprehensive_report = Reports::ComprehensiveReport.new(comprehensive_report_params)

    respond_to do |format|
      if @comprehensive_report.valid?
        format.html { redirect_to reports_comprehensive_reports_path(reports_comprehensive_report: comprehensive_report_params.to_h) }
      else
        format.html { render :new }
      end
    end
  end

  def index
  	@comprehensive_report = Reports::ComprehensiveReport.new(comprehensive_report_params)
  end

  private

    def comprehensive_report_params
      if params[:reports_comprehensive_report].blank?
        []
      else
        params.require(:reports_comprehensive_report).permit(:start_date, :end_date, :project_id, :user_id)
      end

    end

end
