class Reports::InvoiceReportsController < ApplicationController
  before_action :require_admin

  def new
    @invoice_report = Reports::InvoiceReport.new
  end

  def create
    @invoice_report = Reports::InvoiceReport.new(invoice_report_params)

    respond_to do |format|
      if @invoice_report.valid?
        format.html { redirect_to reports_invoice_reports_path(reports_invoice_report: invoice_report_params.to_h) }
      else
        format.html { render :new }
      end
    end
  end

  def index
    @invoice_report = Reports::InvoiceReport.new(invoice_report_params)
  end

  private

    def invoice_report_params
      if params[:reports_invoice_report].nil?
        redirect_to(new_reports_invoice_report_path, alert: "Incomplete report parameters")
        return {}
      end
      params.require(:reports_invoice_report).permit(:start_date, :end_date, :project_id)
    end
end
