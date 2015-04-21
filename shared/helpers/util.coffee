#= base
Util = {} unless Util?


###
Examines a value, and if it's a function, executes it.
@param value:        The value to operate on.
@param defaultValue: Optional.  Value to return if a value is not specified or derived from the function.
###
Util.asValue = (value, defaultValue) ->
  value = value() if Object.isFunction(value)
  if value is undefined
    defaultValue
  else
    value



###
Examines a value, if it's a function, executes it, returning the first value that is found.

@param value:         The value to operate on.
                      If multiple values are passed, the first value that is not [undefined] is returned.
                      NB: This is helpful when attempting to get the first value from a number
                          of different possible sources the value could have been declarted,
                          eg. [data] or [options] on a visual control.

@param defaultValue: Optional.  Value to return if a value is not specified or derived from the function.
###
Util.firstValue = (values, defaultValue) ->
  values = [values] unless Object.isArray(values)
  for value in values
    if value isnt undefined
      value = Util.asValue(value, defaultValue)
      return value if value isnt undefined

  # No-value.
  defaultValue




###
Determines whether the given value an object (literal or derived).

@param value: The value to examine.
@returns true if the value is a literal of derived object, otherwise false.
###
Util.isObject = (value) ->
  return false unless value?
  switch (typeof value)
    when 'string', 'number', 'boolean', 'function' then false
    else
      not Object.isArray(value) # Is-an-object.




###
A safe way to test any value as to wheather is is "blank"
meaning it can be either:
  - null
  - undefined
  - empty-string.
  - empty-array
###
Util.isBlank = (value) ->
  return true if value is null or value is undefined
  return true if Object.isString(value) and value.isBlank()
  return true if Object.isArray(value) and value.compact().length is 0
  false



###
Determines whether the given value is a number, or can be
parsed into a number.

NOTE: Examines string values to see if they are numeric.

@param value: The value to examine.
@returns true if the value is a number.
###
Util.isNumeric = (value) ->
  return false if Util.isBlank(value)
  number = value.toNumber?()
  return false if number is undefined
  return false if number.toString().length isnt value.toString().length
  return not Object.isNaN(number)




###
Gets whether the app is running on a dev machine.

###
Util.isDev = ->
  if Meteor.isServer
    (process.env.NODE_ENV ? 'development') is 'development'

  else
    hostname = window?.location?.hostname.trim()
    if hostname
      return true if hostname.has(/localhost/g)
    false




###
Determines the parameter names of a function

  See: http://stackoverflow.com/questions/1007981/how-to-get-function-parameter-names-values-dynamically-from-javascript

@param func: The function to examine.
@returns an array of strings.
###
STRIP_COMMENTS = /((\/\/.*$)|(\/\*[\s\S]*?\*\/))/mg
ARGUMENT_NAMES = /([^\s,]+)/g
Util.params = (func) ->
  return [] unless Object.isFunction(func)
  fnStr = func.toString().replace(STRIP_COMMENTS, '')
  result = fnStr.slice(fnStr.indexOf('(')+1, fnStr.indexOf(')')).match(ARGUMENT_NAMES)
  result = [] if result is null
  result



###
Generates a hash-code for a string.

  See: http://stackoverflow.com/a/15710692

@param text: The string to convert to a hash.
@returns the hash code (number).
###
Util.hash = (text) ->
  hash = 0
  return hash if Object.isString(text) and text.length is 0
  throw new Error('Can only hash strings') unless Object.isString(text)

  text.split("").reduce(
    (a,b) ->
      a=((a<<5)-a)+b.charCodeAt(0)
      return a&a
    ,0)




###
Creates a deep clone of the given object, including clones of all child
objects within the hierarchy.

@param value: The object or array to clone.
@returns the cloned value if it is clonable, otherwise the original value.
###
Util.clone = (value) ->
  return value unless value?

  # Clone array.
  return value.clone() if Object.isArray(value)

  # Clone date.
  return value.clone() if Object.isDate(value)

  # Clone object.
  if Util.isObject(value)
    result = {}
    for key, item of value
      item = Util.clone(item) if Object.isArray(item) or Util.isObject(item) or Object.isDate(item)
      result[key] = item
    return result

  # Finish up - NOT clonable.
  return value



###
Derives the ID from a value.
@param value: The value to examine, finding (in order):
                - {}.id
                - {}._id
                - <original-value>
###
Util.toId = (value) ->
  objectId = ->
        return value.id if value.id
        return value._id if value._id

  if Util.isObject(value)
    result = Util.asValue(objectId())

  else if Object.isFunction(value)
    result = Util.toId(Util.asValue(value))

  else
    result = value # Primitive value.

  # Finish up.
  result


###
Escape possible malicious code
###
Util.escapeHtml = (str) ->
  div = document.createElement('div')
  div.appendChild(document.createTextNode(str))
  div.innerHTML


