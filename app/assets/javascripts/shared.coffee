window.loadShared = ->
  $('.datetime').datetimepicker
    format: 'm/d/Y g:i A',
    formatTime: 'g:i A',
    maxDate: 0,
    scrollMonth: false,
    yearStart: 2016
    yearEnd: new Date().getFullYear()

  $(".date").datetimepicker
    format: 'm/d/Y',
    maxDate: 0,
    timepicker: false,
    scrollMonth: false,
    yearStart: 2016,
    yearEnd: new Date().getFullYear()