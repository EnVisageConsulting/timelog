class PayrollReport
  reportForm: ->
    $(".date").datetimepicker
      format: 'm/d/Y',
      maxDate: 0,
      timepicker: false,
      scrollMonth: false,
      yearStart: 2016,
      yearEnd: new Date().getFullYear()

$(document).on 'reports/payroll_reports.load', (e, obj) =>
  report = new PayrollReport
  report.reportForm()