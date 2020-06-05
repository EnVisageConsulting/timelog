class Dashboard
  hoursChart: (id, title)->
    ctx        = document.getElementById id
    labels     = ctx.dataset.chartLabels.split "|"
    values     = ctx.dataset.chartValues.split "|"
                                        .map (v) -> (Math.round(v * 10) / 10).toFixed(1)
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

  weekHoursCount: ->
    stat     = $("#week_hours_count").find(".stat")[ 0 ]
    endVal   = parseFloat stat.dataset.hours
    startVal = 0
    decimals = if endVal > 0 then 1 else 0

    numAnim = new CountUp stat, startVal, endVal, decimals
    numAnim.start()

  dayHoursCount: ->
    stat     = $("#day_hours_count").find(".stat")[ 0 ]
    endVal   = parseFloat stat.dataset.hours
    startVal = 0
    decimals = if endVal > 0 then 1 else 0

    numAnim = new CountUp stat, startVal, endVal, decimals
    numAnim.start()

ready= ->
  dashboard = new Dashboard
  dashboard.hoursChart("hours_by_week_chart", "Number of Hours by Week")
  dashboard.hoursChart("hours_by_day_chart", "Number of Hours - Last 5 Days")
  dashboard.weekHoursCount()
  dashboard.dayHoursCount()

$(document).on 'dashboard_index.load', (e, obj) =>
  ready()

$(document).on 'turbolinks:load', (e, obj) =>
  if window.location.pathname == '/' #dashboard
    ready()
