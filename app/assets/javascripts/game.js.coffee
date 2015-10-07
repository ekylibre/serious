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

window.initializeMap = (current_participant, game, turns, actorList) ->
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

  # Initialize actors from the actorList array
  actors = map.select "#actors"
    .selectAll "g.actor"
      .data actorList

  # clone the actor templates
  actors.enter()
    .append "g"
      .attr "class", "actor"
      .each (actor, i) ->
        this.actor = actor
        clone = d3.select if i < 2 then "#acteur-entrepot1" else if i < 4 or i == 6 then "#acteur-entrepot2" else if i < 7 then "#acteur-entrepot3" else if i < 19 then "#acteur-tour" else "#acteur-entrepot1"
          .node()
            .cloneNode true
        clone.removeAttribute "id"
        this.appendChild clone
        # TODO: show affairs count
        #$.ajax {
        #  url: "/participants/#{current_participant.id}/affairs_with/#{actor.id}"
        #  dataType: 'json',
        #  async: true,
        #  success: (affairs) ->
        #  error: (jqXHR, textStatus, errorThrown) ->
        #    console.log textStatus + "\n" + jqXHR.responseText
        #}
      .style "transform", (actor, i) ->
        placeholder = d3.select("#acteur-" + i).select("circle")
        "translate(#{ placeholder.attr 'cx' }px, #{ placeholder.attr 'cy' }px)"
      .attr "id", (actor) -> "actor#{actor.id}"

  # show actor names and stand numbers
  actors
    .select "text:nth-of-type(1)"
      .text (actor) ->
        actor.name
  actors.each (actor) ->
    sign = d3.select "#actor#{actor.id}"
      .select ".sign"
    if actor.present
      sign.select "text"
        .text (actor) ->
          actor.stand_number
    else
      sign.style "display", "none"

  # Display news and curves for the current turn
  broadcastContentRect = d3.select "#broadcastContent"
  d3.select "#broadcastsWindow"
    .append "foreignObject"
      .attr "x", broadcastContentRect.attr "x"
      .attr "y", broadcastContentRect.attr "y"
      .attr "width", broadcastContentRect.attr "width"
      .attr "height", broadcastContentRect.attr "height"
        .append "xhtml:body"
          .append "div"
            .attr "id", "broadcastsContainer"
            .append "div"
              .attr "id", "broadcastsWindowDiv"

  hideBroadcasts = () ->
    d3.select "#broadcasts"
      .transition()
        .style "right", "-450px"
    d3.select "#broadcasts"
      .on "click", () ->
        showBroadcasts()
  showBroadcasts = () ->
    d3.select "#broadcasts"
      .transition()
        .style "right", "0px"
    d3.select "#broadcasts"
      .on "click", () ->
        hideBroadcasts()
  updateBroadcasts = () ->
    $.ajax {
      url: "/games/#{game.id}/current_turn_broadcasts_and_curves",
      dataType: 'json',
      async: true,
      success: (broadcasts_and_curves) ->
        div = d3.select "#broadcastsWindowDiv"
        div.selectAll "p"
          .remove()
        broadcasts_and_curves.broadcasts.forEach (broadcast) ->
          div.append "p"
            .attr "class", "broadcastName"
            .text broadcast.name
          div.append "p"
            .attr "class", "broadcastContent"
            .text broadcast.content
        $.ajax {
          url: "/games/#{game.id}/current-turn",
          dataType: 'json',
          async: true,
          success: (turn) ->
            now = new Date()
            later = new Date turns[turn.number - 1].stopped_at
            interval = later - now + 1
            window.setTimeout updateBroadcasts, interval
            showBroadcasts()
          error: (jqXHR, textStatus, errorThrown) ->
            console.log "error while retreiving current-turn: " + textStatus + "\n" + jqXHR.responseText
        }
        # TODO: curves
      error: (jqXHR, textStatus, errorThrown) ->
        d3.select "#broadcastWindowDiv"
          .append "p"
            .text textStatus + "\n" + jqXHR.responseText
    }
  updateBroadcasts()

  # Setup the actorWindow
  actorContentRect = d3.select "#actorContentRect"
  d3.select "#actorWindowGroup"
    .append "foreignObject"
      .attr "x", actorContentRect.attr "x"
      .attr "y", actorContentRect.attr "y"
      .attr "width", actorContentRect.attr "width"
      .attr "height", actorContentRect.attr "height"
        .append "xhtml:body"
          .attr "id", "actorWindowBody"

  # click on an actor to open the actor window
  actors.on "click", () ->
    return if d3.select("#actorWindow").style("display") == "block"
    disableMouse()
    d3.select "#actorWindowBody"
      .selectAll "*"
        .remove()
    d3.select "#nomActeur"
      .text this.actor.name
    d3.select "#actorWindow"
      .style "display", "block"
    d3.select "#closeActorWindowButton"
      .on "click", () ->
        d3.select "#actorWindow"
          .style "display", "none"
        d3.select "#closeActorWindowButton"
          .on "click", null
        enableMouse()
    $.ajax {
      url: "/participants/#{this.actor.id}?nolayout=true",
      dataType: 'xml',
      async: true,
      success: (content) ->
        d3.select "#actorWindowBody"
          .node()
            .appendChild content.firstChild
      error: (jqXHR, textStatus, errorThrown) ->
        d3.select "#actorWindowBody"
          .append "p"
            .text textStatus + "\n" + jqXHR.responseText
    }
