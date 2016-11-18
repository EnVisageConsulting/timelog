class Session
  sessionForm: ->
    $employeeField = $("#employee_id")
    $employeeField.garlic()

$(document).on 'sessions_new.load sessions_create.load', (e, obj) =>
  session = new Session
  session.sessionForm()