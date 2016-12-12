class Log
  logForm: ->
    $form = $("form")

    $form.find '.datetime'
         .datetimepicker
          format: 'm/d/Y g:i A',
          formatTime: 'g:i A',
          maxDate: 0,
          scrollMonth: false,
          yearStart: 2016
          yearEnd: new Date().getFullYear()

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


    $endAt.on   "change", updateTotalHours
    $startAt.on "change", updateTotalHours

    updateTotalHours()


$(document).on 'logs_edit.load logs_update.load', (e, obj) =>
  log = new Log
  log.logForm()
