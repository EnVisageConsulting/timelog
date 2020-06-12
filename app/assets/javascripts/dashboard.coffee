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

  loadTableTabs: ->
    window_hash = window.location.hash

    if window_hash and $('.table-tabs table'+window_hash).length > 0
      $(".table-tabs .table").hide()
      $(".table-tabs table" + window_hash).show()
      $('.tabs-nav li a[href="'+window_hash+'"]')
        .parent 'li'
        .addClass 'active-tab'
    else
      $(".table-tabs .table")
        .hide()
        .first()
        .show()
      $(".tabs-nav li")
        .first()
        .addClass "active-tab"

    $(".tabs-nav li a").on 'click', (event) ->
      id = this.hash

      $(".tab-table").hide() # hide all tables
      $(id).show() # show table

      $(".tabs-nav .active-tab").removeClass "active-tab"
      $(this)
        .parent 'li'
        .addClass 'active-tab'

      event.preventDefault()

ready= ->
  dashboard = new Dashboard
  dashboard.hoursChart("hours_by_week_chart", "Number of Hours by Week")
  dashboard.hoursChart("hours_by_day_chart", "Number of Hours - Last 5 Days")
  dashboard.weekHoursCount()
  dashboard.dayHoursCount()
  #dashboard.loadTableTabs()

$(document).on 'dashboard_index.load', (e, obj) =>
  ready()

$(document).on 'turbolinks:load', (e, obj) =>
  if window.location.pathname == '/' #dashboard
    ready()
