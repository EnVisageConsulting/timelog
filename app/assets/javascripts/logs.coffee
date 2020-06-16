class Log
  logForm: ->
    $(".datetime-setter").on "click", (e) ->
      e.preventDefault()

      value  = moment().format 'MM/DD/YYYY h:mm A'
      $input = $(this).closest '.input-group'
                      .find    '.input-group-field'

      $input.val     value
            .trigger 'change'


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

$(document).on 'logs_edit.load logs_update.load', (e, obj) =>
  log = new Log
  log.logForm()
