window.loadReport = ->
  $('#select-all').click ->
    if $('#select-all').text() == 'Select All'
      selected = []
      $('.multiselect-users').find('option').each (i, e) ->
        selected[selected.length] = $(e).attr('value')
        return
      $('.multiselect-users').val selected
    else
      $('.multiselect-users').val []
    $('.multiselect-users').trigger 'change'
    false

  $('.multiselect-users').change ->
    optionCount = $('.multiselect-users').find('option').length
    numSelected = $('.multiselect-users').val()
    if numSelected == null or numSelected.length < optionCount / 2
      $('#select-all').text 'Select All'
    else
      $('#select-all').text 'Deselect All'
    return

  $('.multiselect-users').trigger 'change'

  $(".log-date-button").click (e) ->
    e.preventDefault()
    dates = $(this).data("dates")
    $("#reports_personal_report_start_date").val(dates[0])
    $("#reports_personal_report_end_date").val(dates[1])
    $("#new_reports_personal_report").submit()
    $(".log-date-button").attr("disabled", true)

  $("#summary-view-button").on "click", ->
    $("#full-view-li").removeClass("active-tab")
    $("#summary-view-li").addClass("active-tab")
    $("#full-view").hide()
    $("#summary-view").show()

  $("#full-view-button").on "click", ->
    $("#summary-view-li").removeClass("active-tab")
    $("#full-view-li").addClass("active-tab")
    $("#summary-view").hide()
    $("#full-view").show()

