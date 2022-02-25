class window.Report
  constructor: ->
    $('#select-all-users').on "click", () ->
      selectAllClick($('#select-all-users'), $('.multiselect-users'))

    $('#select-active-users').on "click", () ->
      selectAllClick($('#select-active-users'), $('.multiselect-users'))

    $('.multiselect-users').on "change", () ->
     selectAllChange($('#select-all-users'), $('#select-active-users'), $('.multiselect-users'))

    $('.multiselect-users').trigger 'change'

    $('#select-all-projects').on "click", () ->
      selectAllClick($('#select-all-projects'), $('.multiselect-projects'))

    $('#select-active-projects').on "click", () ->
      selectAllClick($('#select-active-projects'), $('.multiselect-projects'))

    $('.multiselect-projects').on "change", () ->
     selectAllChange($('#select-all-projects'), $('#select-active-projects'), $('.multiselect-projects'))

    $('.multiselect-projects').trigger 'change'

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

  selectAllClick= (selectLink, selectInput) ->
    if selectLink.text().startsWith('Select')
      selected = []
      if selectLink.text().endsWith('Active')
        selectInput.find('option').each (i, e) ->
          if $(e).data('active')
            selected[selected.length] = $(e).attr('value')
          return
      else
        selectInput.find('option').each (i, e) ->
          selected[selected.length] = $(e).attr('value')
          return
      selectInput.val selected
    else
      selectInput.val []

    selectInput.trigger 'change'
    false

  selectAllChange= (selectAllLink, selectActiveLink, selectInput, text) ->
    optionCount = selectInput.find('option').length
    numSelected = selectInput.val()
    if numSelected == null or numSelected.length < optionCount / 2
      selectAllLink.text 'Select All'
    else
      selectAllLink.text 'Deselect All'
    return
