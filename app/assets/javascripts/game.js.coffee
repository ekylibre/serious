# Sets SVG pand and zoom

(($) ->
  "use strict"

  $(document).ready ->
    map = $('svg#map')
    svgPanZoom map[0],
      zoomEnabled: true
      maxZoom: 15
      viewportSelector: map.find("g#viewport")[0]

) jQuery
