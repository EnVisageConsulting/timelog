class Dashboard
  hoursChart: ->
    ctx        = document.getElementById "hours_chart"
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
          text: 'Number of Hours by Week'
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

$(document).on 'dashboard_index.load', (e, obj) =>
  dashboard = new Dashboard
  dashboard.hoursChart()
  dashboard.weekHoursCount()