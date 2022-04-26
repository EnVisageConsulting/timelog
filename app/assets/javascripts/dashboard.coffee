class Dashboard
  hoursCounter: (id) ->
    stat     = $("##{id}").find(".stat")[ 0 ]
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
    ctx = document.getElementById 'hours-chart'
    labels = ctx.dataset.chartLabels.split "|"
    values = ctx.dataset.chartValues.split "|"
                                    .map (v) -> (Math.round(v * 10) / 10).toFixed(1)
    title = "Number of Hours Over Time"

    window.hoursChart = new Chart ctx,
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

  disable_necessary_fields: (numerical_fields_shown) ->
    $('#unit_amount').attr('disabled',  !numerical_fields_shown)
    $('#unit_amount_null').attr('disabled', numerical_fields_shown)
    $('#unit_type').attr('disabled', !numerical_fields_shown)
    $('#unit_type_null').attr('disabled', numerical_fields_shown)

    $('#start_date').attr('disabled', numerical_fields_shown)
    $('#start_date_null').attr('disabled', !numerical_fields_shown)
    $('#end_date').attr('disabled', numerical_fields_shown)
    $('#end_date_null').attr('disabled', !numerical_fields_shown)

  check_for_invalid_dates: ->
    start = new Date($('#start_date').val())
    end = new Date($('#end_date').val())
    curr = new Date()

    if !isNaN(start) && !isNaN(end)
      if (start.getFullYear() >= 2016) && (end.getFullYear() >= 2010) && (start <= end) && (start <= curr) && (end <= curr)
        $('#generate-button').attr('disabled', false)
      else
        $('#generate-button').attr('disabled', true)
    else
      $('#generate-button').attr('disabled', true)

ready= ->
  dashboard = new Dashboard
  dashboard.generateHoursChart()
  dashboard.hoursCounter("day_hours_count")
  dashboard.hoursCounter("week_hours_count")
  dashboard.hoursCounter("chart_total_hours")

  if $('#numerical-filter').is(':visible')
    $('#date-range-filter-arrow').removeClass('fa-caret-down').addClass 'fa-caret-right'
    $('#numerical-filter-arrow').removeClass('fa-caret-right').addClass 'fa-caret-down'
    dashboard.disable_necessary_fields(true)
  else
    $('#numerical-filter-arrow').removeClass('fa-caret-down').addClass 'fa-caret-right'
    $('#date-range-filter-arrow').removeClass('fa-caret-right').addClass 'fa-caret-down'
    dashboard.check_for_invalid_dates()
    dashboard.disable_necessary_fields(false)

  $('#unit_amount').on 'keyup', =>
    if ($('#unit_amount').val() > 30) || ($('#unit_amount').val() == "") || ($('#unit_amount').val() < 1)
      $('#generate-button').attr('disabled', true)
    else
      $('#generate-button').attr('disabled', false)

  $('#start_date').on 'keyup change', =>
    dashboard.check_for_invalid_dates()

  $('#end_date').on 'keyup change', =>
    dashboard.check_for_invalid_dates()

  $('#numerical-filter-header').on 'click', ->
    $('#numerical-filter').toggle()

    if $('#date-range-filter').is(':visible')
      $('#date-range-filter').toggle()

    if $('#numerical-filter-arrow').hasClass('fa-caret-right')
      $('#numerical-filter-arrow').removeClass('fa-caret-right').addClass 'fa-caret-down'
      $('#date-range-filter-arrow').removeClass('fa-caret-down').addClass 'fa-caret-right'

      dashboard.disable_necessary_fields(true)

      if ($('#unit_amount').val() > 30) || ($('#unit_amount').val() == "") || ($('#unit_amount').val() < 1)
        $('#generate-button').attr('disabled', true)
      else
        $('#generate-button').attr('disabled', false)
    else
      $('#numerical-filter-arrow').removeClass('fa-caret-down').addClass 'fa-caret-right'

      if $('#date-range-filter-arrow').hasClass('fa-caret-right')
        $('#generate-button').attr('disabled', true)

  $('#date-range-filter-header').on 'click', ->
    $('#date-range-filter').toggle()

    if $('#numerical-filter').is(':visible')
      $('#numerical-filter').toggle()

    if $('#date-range-filter-arrow').hasClass('fa-caret-right')
      $('#date-range-filter-arrow').removeClass('fa-caret-right').addClass 'fa-caret-down'
      $('#numerical-filter-arrow').removeClass('fa-caret-down').addClass 'fa-caret-right'

      dashboard.disable_necessary_fields(false)

      if $('#generate-button').is(':disabled')
        $('#generate-button').attr('disabled', false)

      dashboard.check_for_invalid_dates()
    else
      $('#date-range-filter-arrow').removeClass('fa-caret-down').addClass 'fa-caret-right'

      if $('#numerical-filter-arrow').hasClass('fa-caret-right')
        $('#generate-button').attr('disabled', true)

$(document).on 'turbolinks:load', (e, obj) =>
  if window.location.pathname == '/' #dashboard
    ready()