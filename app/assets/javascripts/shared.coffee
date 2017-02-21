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


  # Animated clock in <title> attribute

  showClock = $("body").data "current-log"
  showClock = showClock == "true" if typeof showClock == "string"

  if showClock
    title   = document.getElementsByTagName("title")[0]
    origTxt = title.textContent
    clocks  = ["&#128347;","&#128336;","&#128337;","&#128338;","&#128339;","&#128340;","&#128341;","&#128342;","&#128343;","&#128344;","&#128345;","&#128346;"]
    counter = 0

    updateClock = ->
      title.innerHTML = clocks[counter%clocks.length] + " " + origTxt
      counter++

    updateClock()
    setInterval updateClock, 1000

