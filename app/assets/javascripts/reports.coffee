window.loadReport = ->
  $('#select-all').click ->
    if $('#select-all').text() == 'Select All'
      selected = []
      $('.multiselect').find('option').each (i, e) ->
        selected[selected.length] = $(e).attr('value')
        return
      $('.multiselect').val selected
    else
      $('.multiselect').val []
    $('.multiselect').trigger 'change'
    false

  $('.multiselect').change ->
    optionCount = $('.multiselect').find('option').length
    numSelected = $('.multiselect').val()
    if numSelected == null or numSelected.length < optionCount / 2
      $('#select-all').text 'Select All'
    else
      $('#select-all').text 'Deselect All'
    return

  $('.multiselect').trigger 'change'

  $(".log-date-button").click (e) ->
    e.preventDefault()
    dates = $(this).data("dates")
    $("#reports_payroll_report_start_date").val(dates[0])
    $("#reports_payroll_report_end_date").val(dates[1])
    $("#new_reports_payroll_report").submit()
    $(".log-date-button").attr("disabled", true)
