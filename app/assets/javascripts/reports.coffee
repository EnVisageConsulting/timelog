class window.Report
  constructor: ->
    $(".log-date-button").click (e) ->
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

    $('#select-active-users').on "click", () ->
      selectAllClick($('#select-active-users'), $('.multiselect-users'))

    $('.multiselect-users').on "change", () ->
      selectAllChange($('#select-active-users'), $('.multiselect-users'))

    $('.multiselect-users').trigger 'change'

    $('#select-active-projects').on "click", () ->
      selectAllClick($('#select-active-projects'), $('.multiselect-projects'))

    $('.multiselect-projects').on "change", () ->
      selectAllChange($('#select-active-projects'), $('.multiselect-projects'))

    $('.multiselect-projects').trigger 'change'

  selectAllClick= (selectLink, selectInput) ->
    if selectLink.text().startsWith('Select')
      selected = []
      selectInput.find('option').each (i, e) ->
        if $(e).data('active')
          selected[selected.length] = $(e).attr('value')
        return
      selectInput.val selected
    else
      selectInput.val []

    selectInput.trigger 'change'
    false

  selectAllChange= (selectActiveLink, selectInput) ->
    optionCount = selectInput.find('option').length
    numSelected = selectInput.val()
    if numSelected == null || numSelected.length < optionCount / 2
      selectActiveLink.text 'Select All Active'
    else
      selectActiveLink.text 'Deselect All Active'
    return
