(($) ->
  'use strict'

  $.countdown =
    render: (element, stopped_at)->
      difference = (stopped_at - Date.now()) / 1000
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

      if difference < 0
        $.countdown.stop(element)
        element.trigger('countdown:finished')
        return

      element.html html

    # Start countdown clearing the interval
    start: (element, delay = 1000, stopped_at = null) ->
      stopped_at ?= new Date(element.data('countdown'))
      console.log "Start countdown from #{new Date(Date.now())} to #{stopped_at}"
      $.countdown.stop(element)
      $.countdown.render(element, stopped_at)
      element.prop('interval', setInterval($.countdown.render.bind(null, element, stopped_at), delay))

    # Stop countdown clearing the interval
    stop:(element) ->
      if element.prop('interval')
        window.clearInterval(element.prop('interval'))


  $(document).on "page:before-unload",  ->
    $('*[data-countdown]').each  ->
      $.countdown.stop($(this))

  $(document).on "page:change",  ->
    $('*[data-countdown]').each  ->
      $.countdown.start($(this))


  $(document).on 'countdown:finished', '*[data-countdown-restart]', ->
    $.ajax
      url: $(this).data('countdown-restart')
      datatype: 'JSON'
      error: (request, status, error) =>
        console.error(error)
        $.countdown.stop($(this))

      success: (data, status, request) =>
        if data.name isnt null
          $(this).trigger('countdown:restart', data)
          $.countdown.start($(this), 1000, new Date(data.stopped_at))
        else if data.state == 'finished'
          $(this).html('Partie terminée')
        else
          $(this).html('Partie inactive')

  $(document).on 'countdown:restart', '#main-countdown', (event, turn) ->
    $('#turn-name').html(turn.name)

  $(document).on 'countdown:restart','.simple-countdown', (event, turn) ->
    countdown = $(this).closest('.countdown')
    countdown.find('.turn-number').html(turn.number)
    countdown.find('.turns-count').html(turn.turns_count)

) jQuery
