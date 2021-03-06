#= base
cache = {}


###

Safely creates the given namespace on the root object
and caches the value for quicker response times
on subsequent calls.

@param root:      (optional) The root object
@param namespace: The dot-delimited NS string (excluding the root object).

@returns the child object of the namespace.
###
Util.ns = (namespace) ->
  # Check whether the NS has already been created.
  cached = cache[namespace]
  return cached if cached?

  # Build the namespace.
  result = Util.ns.get(namespace)

  # Finish up.
  cache[namespace] = result
  result




###
Safely creates the given namespace on the root object.

@param root:      (Optional) The root object.
@param namespace: The dot-delimited NS string (excluding the root object).

@returns the child object of the namespace.
###
Util.ns.get = (root, namespace) ->
  if Object.isString(root) or Object.isArray(root)
    namespace = root
    root = null

  return if Util.isBlank(namespace)
  root ?= (global ? window)

  getOrCreate = (parent, name) ->
      parent[name] ?= {}
      parent[name]

  add = (parent, parts) ->
      part = getOrCreate parent, parts[0]
      if parts.length > 1
        parts.splice(0, 1)
        part = add part, parts  # <= RECURSION.
      part

  # Build the namespace.
  namespace = namespace.split('.') unless Object.isArray(namespace)
  result = add(root, namespace)




###
Retrieves the value at the end of the given namespace string.
@param namespace: The namespace string.
###
Util.ns.toValue = (namespace) ->
  return if Util.isBlank(namespace)
  parts = namespace.split('.')
  return if parts.length is 0

  result = global ? window
  for part, i in parts
    result = result[part]
    return unless result?

  result





###
Reads the namespace path, retrieving the value as a function.
@param namespace: The namespace string.
###
Util.ns.toFunction = (namespace) ->
  result = Util.ns.toValue(namespace)
  result if Object.isFunction(result)

