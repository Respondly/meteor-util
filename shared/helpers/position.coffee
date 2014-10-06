###
Parses an edge value into a compound object.
@param text:
               Two part value, "x,y"
                  X: 'left', 'center', 'right'
                  y: 'top', 'middle', 'bottom'
###
Util.toEdge = (text) ->
  # Setup initial conditions.
  return null if Util.isBlank(text)
  text  = text.toLowerCase()
  parts = text.split(',').map (part) -> part.trim()

  # Extract X:Y values.
  horizontal = ['left', 'center', 'right']
  vertical   = ['top', 'middle', 'bottom']

  isHorizontal = (value) -> horizontal.any (item) -> item is value
  isVertical   = (value) -> vertical.any (item) -> item is value

  result = {}
  for part in parts
    result.x = part if isHorizontal(part)
    result.y = part if isVertical(part)

  # Top up with default values.
  result.x ?= 'left'
  result.y ?= 'top'

  # Finish up.
  result





###
Calculates a {left|top} position relative to an edge.
@param size:            The size of the element to calculate position of { width|height }
@param relativeToRect:  The rectangle to calculate the position relative to { left|top|width|height }
@param options:
          - edge: String. The edge to calculation position relative to:

                               Two part value, "x,y",
                                  X: 'left', 'center', 'right'
                                  y: 'top', 'middle', 'bottom'
                                Example:
                                  'top,left'

          - align:  X:Y instructions for whether to align the object inside or outside.
                    Values:
                      - inside (default)
                      - center
                      - outside

                    Example:
                      'inside,outside'
                      { x:'inside', y:'outside' }

          - offset: {top|left} pixel value to adjust the result by.

@returns a position object { left|top }.
###
Util.relativePosition = (size, relativeToRect, options = {}) ->
  # Setup initial conditions.
  edge  = options.edge ? 'top,left'
  edge  = Util.toEdge(edge)

  # Parse edge-alignment.
  align = options.align ? { x:'inside', y:'inside' }
  align = Util.toCompoundValue(align, { '0':'x', '1':'y' })

  # Calculate base X:Y positions.
  left = switch edge.x
          when 'left'   then relativeToRect.left
          when 'center' then relativeToRect.left + (relativeToRect.width / 2)
          when 'right'  then relativeToRect.left + relativeToRect.width

  top = switch edge.y
          when 'top'    then relativeToRect.top
          when 'middle' then relativeToRect.top + (relativeToRect.height / 2)
          when 'bottom' then relativeToRect.top + relativeToRect.height

  # Adjust for edge-alignment.
  switch align.x
    when 'inside'  then left -= size.width if edge.x is 'right'
    when 'center'  then left -= size.width / 2
    when 'outside' then left -= size.width if edge.x is 'left'

  switch align.y
    when 'inside'  then top -= size.height if edge.y is 'bottom'
    when 'center'  then top -= size.height / 2
    when 'outside' then top -= size.height if edge.y is 'top'

  # Offset.
  if offset = options.offset
    offset = Util.toPosition(offset) if Object.isString(offset) or Object.isNumber(offset)
    left += offset.left
    top  += offset.top

  # Finish up.
  { left:left.round(), top:top.round() }





