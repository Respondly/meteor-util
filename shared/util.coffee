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

  See: http://stackoverflow.com/a/7616484/1745661

@param text: The string to convert to a hash.
@returns the hash code (number).
###
Util.hash = (text) ->
  hash = 0
  return hash if Object.isString(text) and text.length is 0
  throw new Error('Can only hash strings') unless Object.isString(text)

  for chr in text
    chr = chr.charCodeAt(0)
    hash  = ((hash << 5) - hash) + chr
    hash |= 0 # Convert to 32-bit integer.

  return hash
