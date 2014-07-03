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
