window.loadReport = ->
  $(".date").datetimepicker
    format: 'm/d/Y',
    maxDate: 0,
    timepicker: false,
    scrollMonth: false,
    yearStart: 2016,
    yearEnd: new Date().getFullYear()