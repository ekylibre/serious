#= require bootstrap/tooltip
# Sets SVG pand and zoom
#
(($) ->
  "use strict"

  $(document).ready ->
    $('*[data-toggle="tooltip"]').tooltip()

  $(document).on "page:load", ->
    $('*[data-toggle="tooltip"]').tooltip()

#  $.loadMap = ->
#    map = $('svg#map')
#    svgPanZoom map[0],
#      zoomEnabled: true
#      maxZoom: 15
#      viewportSelector: map.find("g#viewport")[0]
#
#
#  $(document).ready ->
#    $.loadMap()
#
#  $(document).on "page:load", ->
#    $.loadMap()

) jQuery


