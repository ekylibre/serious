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

window.initializeMap = (actorList) ->
  # MAP AUTOMATIC MOVEMENT

  container = d3.select "#mapcontainer"
  map = d3.select "#map"

  offset = (mouse) ->
     # returns the point of the map that should be on the top left corner
    containerWidth  = parseInt container.style 'width'
    containerHeight = parseInt container.style 'height'
    mapWidth  = parseInt map.style 'width'
    mapHeight = parseInt map.style 'height'
    if mouse == null
      # no mouse position yet, let's say we want to be in the middle by default
      mouse = [containerWidth / 2 , containerHeight / 2]
    [
      Math.round(mouse[0] * (mapWidth  - containerWidth ) / containerWidth ),
      Math.round(mouse[1] * (mapHeight - containerHeight) / containerHeight)
    ]

  # Initialize the current offset to the default offset (to show the center of the map)
  currentOffset = offset null

  # and we want to stay there for now
  targetOffset = currentOffset

  # we are not moving
  idle = true

  # 'transform' is called something else on various old browsers
  style = document.body.style
  transform = if "webkitTransform" in style then "-webkit-" else if "MozTransform" in style then "-moz-" else if "msTransform" in style then "-ms-" else if "OTransform" in style then "-o-" else ""
  transform += "transform"

  mouseEnabled = true

  disableMouse = () ->
    # ignore the mouse moves
    mouseEnabled = false

  enableMouse = () ->
    # user can move map with the mouse
    mouseEnabled = true

  # Translate the map to move closer to the target
  move = () ->
    if Math.abs(targetOffset[0] - currentOffset[0]) < .5 && Math.abs(targetOffset[1] - currentOffset[1]) < .5
      # target is less than half a pixel away, stop there
      currentOffset = targetOffset
      if !mouseEnabled
        d3.timer enableMouse, 1000
      idle = true
    else
      # still far, get closer
      currentOffset[0] += (targetOffset[0] - currentOffset[0]) * .14
      currentOffset[1] += (targetOffset[1] - currentOffset[1]) * .14
      idle = false
    map.style transform, "translate( #{ -currentOffset[0] }px, #{ -currentOffset[1] }px )"
    idle

  moved = () ->
    # call move when relevant
    if idle
      d3.timer move

  centerMap = () ->
    # move to the center of the map
    targetOffset = offset null
    moved()

  d3.select(window).on("resize", centerMap).each(centerMap)

  mousemoved = () ->
    # follow to the mouse cursor
    if mouseEnabled
      targetOffset = offset(d3.mouse(this))
      moved()
  container.on("mousemove", mousemoved)

  forceCenterMap = () ->
    disableMouse()
    centerMap()

  forceCenterMap()


  elementCenter = (element) ->
    # returns the element's center coordinates
    rect = element.node().getBoundingClientRect()
    [
      rect.left + rect.width/2,
      rect.top + rect.height/2
    ]

  # move the models to 0,0 (and out of the view of the users)
  # FIXME : move these templates out of the support SVG instead
  [ "#acteur-entrepot1", "#acteur-entrepot2" ].forEach (selector) ->
    actor = d3.select selector
    actorCenter = elementCenter actor
    actor.style "transform", "translate(#{ -actorCenter[0] }px, #{ -actorCenter[1] }px)"

  # hide placeholders FIXME : group them in one single group and hide the group
  d3.select("#acteur-#{i}").style "display", "none" for i in [0..18]

  # Initialize actors from the actorList array
  actors = map.select "svg"
    .append "g"
      .attr "id", "actors"
      .selectAll "g.actor"
        .data actorList

  # and the template
  actors.enter()
    .append "g"
      .attr "class", "actor"
      .each (actor, i) ->
        clone = d3.select if i < 4 then "#acteur-entrepot1" else if i < 7 then "#acteur-entrepot2" else "#acteur-tour"
          .node()
            .cloneNode true
        clone.removeAttribute "id"
        this.appendChild clone
      .style "transform", (actor, i) ->
        placeholder = d3.select("#acteur-" + i).select("circle")
        "translate(#{ placeholder.attr 'cx' }px, #{ placeholder.attr 'cy' }px)"
      .attr "id", (actor) -> "actor#{actor.id}"

  # show its name and its stand number
  actors
    .select "text"
      .text (actor) ->
        console.log actor
        actor.name + if actor.present then " " + actor.stand_number else ""

  # click on an actor to open the actor window
  actors.on "click", () ->
    #d3.select "#actorDialog"
    #  .attr "display" "block"
    # TODO : display actors offer
    forceCenterMap()
