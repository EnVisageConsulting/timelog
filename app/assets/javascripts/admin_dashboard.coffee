class AdminDashboard
  employeeChart: (id, title)->
    ctx        = document.getElementById id
    labels     = ctx.dataset.chartLabels.split "|"
    values     = ctx.dataset.chartValues.split "|"
                                        .map (v) -> (Math.round(v * 100) / 100).toFixed(2)
    hoursChart = new Chart ctx,
      type: 'bar',
      maintainAspectRatio: false,
      data:
        labels: labels,
        datasets: [{
          data: values,
          backgroundColor: '#0EB1FF',
          borderColor: '#2199e8',
          borderWidth: 1
        }]
      options:
        title:
          display: true,
          text: title
        legend:
          display: false
        scales:
          yAxes: [{
            ticks:
              beginAtZero: true
          }]

admin_dashboard_ready= ->
  dashboard = new AdminDashboard
  dashboard.employeeChart("employee_week_chart", "Total Team Member Hours by Week")
  dashboard.employeeChart("employee_month_chart", "Total Team Member Hours by Month")

$(document).on 'admin_dashboard_index.load', (e, obj) =>
  admin_dashboard_ready()

$(document).on 'turbolinks:load', (e, obj) =>
  if window.location.pathname == '/admin_dashboard'
    admin_dashboard_ready()
