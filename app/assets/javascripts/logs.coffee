class Log
  logForm: ->
    enableMultiselect({placeholder: "Project Tags"})

    #load existing project tags
    $(".project-tags").each (id, select) ->
      $(select).val($(select).data("selected")).trigger('change');

    keyboard_input = false
    old_date = ""

    $(".datetime-setter").on "click", (e) ->
      e.preventDefault()

      value  = moment().format 'MM/DD/YYYY h:mm A'
      $input = $(this).closest '.input-group'
                      .find    '.input-group-field'

      keyboard_input = true

      $input.val     value
            .trigger 'change'

    $("#log_start_at, #log_end_at").on "click", (e) ->
      keyboard_input = false
      document.addEventListener 'keydown', (event) ->
        keyboard_input = true

    $("#log_start_at, #log_end_at").on "change", (e) ->
      date = new Date($(this).val());

      if old_date == ""
        old_date = $(this).data("old-date")
      if old_date != undefined
        old_date = new Date(old_date)

      if !keyboard_input && old_date != undefined && !(sameDates(date, old_date))
        hour = date.getHours();

        if hour == 23
          date.setHours(hour - 11);
        else
          date.setHours(hour + 1);

        hour = date.getHours();
        am_pm = "AM"
        if hour >= 12
          am_pm = "PM"
        if hour > 12
          hour = hour - 12
        if hour == 0
          hour = 12
        if hour < 10
          hour = "0" + hour

        month = date.getMonth() + 1;
        if month < 10
          month = "0" + month

        day = date.getDate();
        if day < 10
          day = "0" + day

        min = date.getMinutes();
        if min < 10
          min = "0" + min

        $(this).val(month + "/" + day + "/" + date.getFullYear() + " " + hour + ":" + min + " " + am_pm);
      old_date = date

    $projectLogFields = $("label[for='log_project_logs']").closest 'fieldset'
    $projectLogFields.on "click", ".add-project-link", (e) ->
      e.preventDefault()

      $link        = $(this)
      $projectLogs = $projectLogFields.find '#document_project_logs'
      fieldHash    = $link.data 'field-hash'
      newId        = new Date().getTime()
      regexp       = new RegExp "new_" + fieldHash.association, "g"


      $projectLogs.append fieldHash.content.replace(regexp, newId)
      $newFields = $projectLogs.find('.project-log-fields').last()
      $newFields.find('input[name$="[percent]"]').val ''
      $newFields.find('select[name$="[project_id]"]').focus()
      projectChangeListener()
      enableMultiselect({placeholder: "Project Tags"})


    $projectLogFields.on "click", ".remove-project-link", (e) ->
      e.preventDefault()

      $link         = $(this)
      $fields       = $link.closest '.project-log-fields'
      $destroyField = $fields.find  'input[name$="[_destroy]"]'

      if $projectLogFields.find('.project-log-fields:visible').length <= 1
        alert "Must keep at least 1 project for log"
      else if $destroyField.length > 0
        $destroyField.val 'true'
        $fields.hide()
      else
        $fields.remove()

      projectChangeListener()

    # confirm leaving if there's a change
    formSubmitting = false
    hasChanged = false

    $(".edit_log").on "submit", ->
      formSubmitting = true

    $(".edit_log :input").on "change", ->
      hasChanged = true

    window.addEventListener 'beforeunload', (e) ->
      if formSubmitting or !hasChanged
        return undefined
      confirmationMessage = 'Changes you made may not be saved.'
      (e or window.event).returnValue = confirmationMessage #Gecko + IE
      confirmationMessage #Gecko + Webkit, Safari, Chrome etc.

    $startAt    = $("#log_start_at")
    $endAt      = $("#log_end_at")
    $totalHours = $(".stat")

    updateTotalHours = ->
      startAt = $startAt.val()
      endAt   = $endAt.val()
      value   = '...'

      if startAt != "" && endAt != ""
        mStartAt = moment startAt, "MM/DD/YYYY hh:mm a"
        mEndAt   = moment endAt,   "MM/DD/YYYY hh:mm a"
        diff     = moment.duration(mEndAt.diff(mStartAt)).asMinutes()

        if diff >= 0
         value = (diff / 60).toFixed 2

      $totalHours.text value

      startNewLog = $("#start-new-log")
      startNewLogRow = $("#start-new-log-row")

      if endAt != "" && (startNewLogRow.data('current-log-id') == "" || startNewLogRow.data('current-log-id') == startNewLogRow.data('editing-log-id'))
        startNewLog.show()
      else
        startNewLog.hide()

    $percent_total = $("#total_percent")

    updatePercentage = ->
      total = 0
      $(".percent_field").each (id, field) ->
        if !isNaN(parseInt(field.value))
          total += parseInt(field.value)
      $percent_total.val(total)

    $endAt.on   "change", updateTotalHours
    $startAt.on "change", updateTotalHours
    $(".percent_field").on "change", updatePercentage

    updateTotalHours()

    projectChangeListener = ->
      $projectFields = $("select[id$='_project_id']")
      $projectFields.on "change", distinctProjects
      $projectFields.each distinctProjects
      $(".percent_field").on "change", updatePercentage #restablish trigger

    distinctProjects = ->
      $projectFields = $("select[id$='_project_id']")
      $projectFields.children().removeAttr 'disabled'
      $projectFields.each ->
        unless $(this).val() == ''
          $projectFields.not($(this)).find('option[value=' + $(this).val() + ']').attr 'disabled', 'disabled'

    sameDates = (date1, date2) ->
      date1.getYear() == date2.getYear() && date1.getMonth() == date2.getMonth() && date1.getDate() == date2.getDate()

$(document).on 'logs_edit.load logs_update.load', (e, obj) =>
  log = new Log
  log.logForm()
