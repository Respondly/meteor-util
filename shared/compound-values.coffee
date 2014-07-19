###
Converts an array or string to an {width|height} size object.
@param value:  Either
                - an object {width|height}: no change
                - array [width, height], eg. [20, 30] => {width:20, height:30}
                - string: '30,40'
@returns { width|height } or null if there is no value.
###
Util.toSize = (value...) ->
  if size = Util.toCompoundNumber(value, { '0':'width', '1':'height' })
    new Util.Size(size.width, size.height)
  else
    null

class Util.Size
  constructor: (@width, @height) ->
  toStyle: (unit = 'px') -> "width:#{ @width }#{ unit }; height:#{ @height }#{ unit };"



# ----------------------------------------------------------------------



###
Converts an array or string into a { left|top } object
@param value: Either
                - an object {left|top}: no change
                - array [left, top], eg. [20, 30] => {left:20, top:30}
                - string: '30,40'
@returns { left|top } or null if there is no value.
###
Util.toPosition = (value...) ->
  if position = Util.toCompoundNumber(value, { '0':'left', '1':'top' })
    new Util.Position(position.left, position.top)
  else
    null

class Util.Position
  constructor: (@left, @top) ->
  toStyle: (unit = 'px') -> "left:#{ @left }#{ unit }; top:#{ @top }#{ unit };"



# ----------------------------------------------------------------------



###
Converts an array or string into a { left|top|width|height } object
@param value: Either
                - an object {left|top|width|height}: no change
                - array [left, top], eg. [20, 30, 10, 5] => {left:20, top:30, width:10, height:5}
                - string: '30,40, 10, 5'
@returns { left|top|width|height } or null if there is no value.
###

Util.toRect = (value...) ->
  if rect = Util.toCompoundNumber(value, { '0':'left', '1':'top', '2':'width', '3':'height' })
    new Util.Rectangle(rect.left, rect.top, rect.width, rect.height)
  else
    null


class Util.Rectangle
  constructor: (@left, @top, @width, @height) ->
  toStyle: (unit = 'px') -> "left:#{ @left }#{ unit }; top:#{ @top }#{ unit }; width:#{ @width }#{ unit }; height:#{ @height }#{ unit };"



# ----------------------------------------------------------------------


###
Converts an array or string to an {x|y} size object.
@param value:  Either
                - an object {x|y}: no change
                - array [x, y], eg. [20, 30] => {x:20, y:30}
                - string: '30,40'
@returns { x|y } or null if there is no value.
###
Util.toXY = (value...) -> Util.toCompoundNumber(value, { '0':'x', '1':'y' })



# ----------------------------------------------------------------------


###
Converts value(s) into a object containing multiple properties.
@param value: An array of numbers, can be:
              - a single number.
              - an array of numbers.
              - a comma seperated string.

@param keyNameMap: The map of key-names to indexes.
                   Structure: { 'index':'key-name' }
                   For example:
                      { '0': 'left', '1':'top' }

@returns an object with the compound values split out as properties,
         or null if no value was passed.
###
Util.toCompoundValue = (value..., keyNameMap = {}) ->
  # Setup initial conditions.
  value = value.flatten()
  return null if value.length is 0
  return value[0] if value.length is 1 and Util.isObject(value[0])

  # Parse string.
  if value.length is 1 and Object.isString(value[0])
    text = value[0]
    return null if Util.isBlank(text)
    value = text.split(',').map (part) -> part.trim()

  # Build the compound value.
  result = {}
  for own index, key of keyNameMap
    index = index.toNumber()
    if index.isInteger()
      result[key] = value[index]
      result[key] = value.last() unless result[key]?

  # Finish up.
  result



###
A version of [toCompoundValue] that converts values to numbers.
###
Util.toCompoundNumber = (value..., keyNameMap = {}) ->
  result = Util.toCompoundValue(value, keyNameMap)
  for own key, value of result
    result[key] = value?.toNumber()
  result