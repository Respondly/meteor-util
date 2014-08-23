###
Base class for draggable elements.
###
class Util.Draggable
  constructor: (@el) ->
    setOffset = (x, y) => @offset = { x:x, y:y }
    setOffset(0, 0)

    stopMoveHandler = ->
      $(window).off('mousemove', onMove)
      $(window).off('mouseup', onMouseup)

    onMove = (e) =>
      onStart(e) unless @isDragging
      setOffset(0 - (@startingArgs.clientX - e.clientX), 0 - (@startingArgs.clientY - e.clientY))
      @onDrag(e)

    onMouseup = (e) =>
      $(document).enableSelection() # Re-enabled text selection within the DOM.
      wasDragging = @isDragging
      @isDragging = false
      stopMoveHandler()
      if wasDragging then onStop(e) else @onClick(e)

    onStart = (e) =>
      @isDragging = true
      @startingArgs = e
      @onDragStart(e)

    onStop = (e) =>
      delete @startingArgs
      @onDragStop(e)

    # Wire up events.
    @el.mousedown ->
      $(document).disableSelection() # Prevent seletion of text within the DOM.
      $(window).mousemove onMove
      $(window).mouseup   onMouseup


  ###
  OVERRIDABLE: Invoked at the beginning of the drag operation.
  @param e: Event arguments.
  ###
  onDragStart: (e) ->

  ###
  OVERRIDABLE: Invoked during the drag operation (on mouse-move).
  @param e: Event arguments.
  ###
  onDrag: (e) ->

  ###
  OVERRIDABLE: Invoked at the end of the drag operation.
  @param e: Event arguments.
  ###
  onDragStop: (e) ->


  ###
  OVERRIDABLE: Invoked when a click occurred (instead of a drag).
  @param e: Event arguments.
  ###
  onClick: (e) ->


