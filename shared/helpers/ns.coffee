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


  # throw new Error('A namespace root must be specified') unless Object.isObject(root)



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
@param ns: The namespace string.
###
Util.ns.toValue = (ns) ->
  return if Util.isBlank(ns)
  parts = ns.split('.')
  return if parts.length is 0

  result = global ? window
  for part, i in parts
    result = result[part]
    return unless result?

  result





###
Reads the ns path, retrieving the value as a function.
@param ns: The namespace string.
###
Util.ns.toFunction = (ns) ->
  result = Util.ns.toValue(ns)
  result if Object.isFunction(result)

