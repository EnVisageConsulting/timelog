class Log
  logForm: ->
    $(".datetime-setter").on "click", (e) ->
      e.preventDefault()

      value  = moment().format 'MM/DD/YYYY h:mm a'
      $input = $(this).closest '.input-group'
                      .find    '.input-group-field'

      $input.val value


    $projectLogFields = $("label[for='log_project_logs']").closest 'fieldset'
    $projectLogFields.on "click", ".add-project-link", (e) ->
      e.preventDefault()

      $link      = $(this)
      field_hash = $link.data 'field-hash'
      new_id     = new Date().getTime()
      regexp     = new RegExp "new_" + field_hash.association, "g"

      $link.closest('.row').before field_hash.content.replace(regexp, new_id)
      $link.closest('.row').prev('.project-log-fields').find('select').focus()


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



$(document).on 'logs_edit.load logs_update.load', (e, obj) =>
  log = new Log
  log.logForm()
