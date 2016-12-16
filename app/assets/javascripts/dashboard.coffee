class Dashboard
  hoursChart: ->
    ctx        = document.getElementById "hours_chart"
    labels     = ctx.dataset.chartLabels.split "|"
    values     = ctx.dataset.chartValues.split "|"
                                        .map (v) -> parseInt(v)
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

$(document).on 'dashboard_index.load', (e, obj) =>
  dashboard = new Dashboard
  dashboard.hoursChart()