class Dashboard
  dayHoursCount: ->
    stat     = $("#day_hours_count").find(".stat")[ 0 ]
    endVal   = parseFloat stat.dataset.hours
    startVal = 0
    decimals = if endVal > 0 then 1 else 0

    numAnim = new CountUp stat, startVal, endVal, decimals
    numAnim.start()

  weekHoursCount: ->
    stat     = $("#week_hours_count").find(".stat")[ 0 ]
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

  generateHoursChart: ->
    ctx             = document.getElementById 'hours-chart'
    unit_amount     = document.getElementById('unit-amount').value
    unit_type_id    = document.getElementById 'unit-type'
    unit_type       = unit_type_id.options[unit_type_id.selectedIndex].text
    title           = "Number of Hours - Last " + unit_amount + " " + unit_type

    if unit_amount == ""
      unit_amount = 0

    chartData = unit_type_id.value
    chartData = chartData.split('[').join ''
    chartData = chartData.split(']').join ''
    chartData = chartData.split('"').join ''
    chartData = chartData.split(', ').join '|'

    chartArray = chartData.split '|'
    labels = chartArray.slice((((chartArray.length) / 2) - unit_amount), ((chartArray.length) / 2))
    data = chartArray.slice(chartArray.length - unit_amount, chartArray.length)
                     .map (v) -> (Math.round(v * 10) / 10).toFixed(1)

    window.hoursChart = new Chart ctx,
      type: 'bar',
      maintainAspectRatio: false,
      data:
        labels: labels,
        datasets: [{
          data: data,
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

ready= ->
  dashboard = new Dashboard
  dashboard.generateHoursChart()
  dashboard.dayHoursCount()
  dashboard.weekHoursCount()
  #dashboard.loadTableTabs()

  $('#hours-chart-generate').on 'click', =>
    if window.hoursChart isnt undefined
      window.hoursChart.destroy()
    dashboard.generateHoursChart()

  $('#unit-amount').on 'keyup', =>
    if (document.getElementById('unit-amount').value > 30)
      $('#hours-chart-generate').attr('disabled', true)
    else
      $('#hours-chart-generate').attr('disabled', false)

$(document).on 'dashboard_index.load', (e, obj) =>
  ready()

# $(document).on 'turbolinks:load', (e, obj) =>
#   if window.location.pathname == '/' #dashboard
#     ready()