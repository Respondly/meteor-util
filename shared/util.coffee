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
