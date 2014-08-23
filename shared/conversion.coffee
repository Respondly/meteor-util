
###
Determines whether the given value is true.
@param bool: The boolean value to examine (can be a string).
@param options
          - default: The default value if undefined (default is false).
###
Util.isTrue = (bool, options = {}) ->
  options.default ?= false
  return options.default if bool is undefined
  return true if bool is true
  if Object.isString(bool)
    return true if bool.trim().toLowerCase() is 'true'
  false



###
Determines whether the given value is false (inversion of [isTrue]).
@param bool: The boolean value to examine (can be a string).
@param options
          - default: The default value if undefined (default is false).
###
Util.isFalse = (bool, options = {}) ->
  options.default ?= false
  return options.default if bool is undefined
  return true if bool is false
  if Object.isString(bool)
    return true if bool.trim().toLowerCase() is 'false'
  false



###
Converts a value to boolean (if it can).
@param value: The value to convert.
@returns the converted boolean, otherwise the original value.
###
Util.toBool = (value) ->
  return value unless value?
  return value if Object.isBoolean(value)
  return true if Util.isTrue(value)
  return false if Util.isFalse(value)
  value
