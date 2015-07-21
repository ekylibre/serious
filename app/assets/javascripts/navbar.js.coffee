(($) ->
  'use strict'
  $.countdown =
    render: (element)->
      date_end_turn = new Date(element.data('countdown'))
      difference = (date_end_turn - Date.now())/1000
      duration =
        days: 0
        hours: 0
        min: 0
        sec: 0

      if difference <= 0
        $.countdown.stop(element)
        return duration

      if difference >= 86400
        duration.days = Math.floor(difference / 86400)
        difference -= duration.days * 86400
      if difference >= 3600
        duration.hours = Math.floor(difference / 3600)
        difference -= duration.hours * 3600
      if difference >= 60
        duration.min = Math.floor(difference / 60)
        difference -= duration.min * 60


      duration.sec = Math.round(difference)
      duration

      if duration.days > 0
        html = "#{duration.days}j #{duration.hours}h"
      else if duration.hours > 0
        html = "#{duration.hours}h #{duration.min}min"
      else if duration.min > 0
        html = "#{duration.min}min #{duration.sec}s"
      else if duration.sec > 0
        html = "#{duration.sec}s"
      element.html html

    start: (element, delay = 1000) ->
      @tab_element.push element
      element.prop('interval', setInterval($.countdown.render.bind(null, element), delay))

    stop:(element) ->
      window.clearInterval(element.prop('interval'))

  $(document).ready ->
    $.countdown.tab_element = []
    $('*[data-countdown]').each ->
      $.countdown.start($(this))

  $(document).on "page:load", ->
    for tab in $.countdown.tab_element
      $.countdown.stop(tab)
    $('*[data-countdown]').each ->
      $.countdown.start($(this))


) jQuery