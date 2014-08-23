db = Util.db ?= {}



###
Converts a selector that can be stored in the DB into an active selector.

      Namely $ symbols cannot be stored in Mongo as keys.
      This method replaces '__' with '$' for example:

          { orgRef:{ __ne:null }}

      would be converted to:

          { orgRef:{ $ne:null }}

###
db.formatSelector = (selector = {}) ->
  for key, value of selector
    # Replace symbols.
    if key.startsWith('__')
      delete selector[key]
      key = '$' + key.remove /^_*/
      selector[key] = value

    # Process child objects.
    db.formatSelector(value) if Util.isObject(value) # <== RECURSION.

  # Finish up.
  selector

