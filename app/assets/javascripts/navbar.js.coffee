(($) ->
  'use strict'
  $.countdown =
    render: (element, date_end_turn)->
      difference = (date_end_turn - Date.now())/1000
      duration =
        days: 0
        hours: 0
        min: 0
        sec: 0

      if difference >= 86400
        duration.days = Math.floor(difference / 86400)
        difference -= duration.days * 86400
      if difference >= 3600
        duration.hours = Math.floor(difference / 3600)
        difference -= duration.hours * 3600
      if difference >= 60
        duration.min = Math.floor(difference / 60)
        difference -= duration.min * 60

      duration.sec = Math.floor(difference)


      if duration.days > 0
        html = "#{duration.days}j #{duration.hours}h"
      else if duration.hours > 0
        html = "#{duration.hours}h #{duration.min}min"
      else if duration.min > 0
        html = "#{duration.min}min #{duration.sec}s"
      else if duration.sec >= 0
        html = "#{duration.sec}s"
      element.html html

      if difference <= 0
        $.countdown.stop(element)


    start: (element, delay = 1000, date_end_turn = null) ->
      @tab_element.push element
      date_end_turn ?= new Date(element.data('countdown'))
      $.countdown.render(element,date_end_turn)
      element.prop('interval', setInterval($.countdown.render.bind(null, element, date_end_turn), delay))

    stop:(element) ->
      window.clearInterval(element.prop('interval'))
      element.trigger('countdown:finished')

  $(document).ready ->
    $.countdown.tab_element = []
    $('*[data-countdown]').each ->
      $.countdown.start($(this))

  $(document).on "page:load", ->
    for tab in $.countdown.tab_element
      $.countdown.stop(tab)
    $('*[data-countdown]').each ->
      $.countdown.start($(this))

  $(document).on 'countdown:finished', '*[data-countdown-restart]', ->
    $.ajax
      url: $(this).data('countdown-restart')
      datatype: 'JSON'
      error: (textStatus) ->
        console.error(textStatus)
      success: (data, textStatus) =>
        if data.state == 'running'
          $(this).trigger('countdown:restart', data)
          $.countdown.start($(this), 1000, new Date(data.stopped_at))
        else if data.state == 'finished'
          $(this).html('partie terminée')

  $(document).on 'countdown:restart', '#main-countdown', (event, turn) ->
    $('#turn-name').html(turn.name)

  $(document).on 'countdown:restart','.turns', (event, data) ->
    $(this).closest('.count-down').find('.turn-number').html(data.number_turn)
    $(this).closest('.count-down').find('.turns-count').html(data.turn_count)

) jQuery