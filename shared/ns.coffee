#= base
cache = {}


###
Safely creates the given namespace on the root object.
@param root:      The root object
@param namespace: The dot-delimited NS string (excluding the root object).
@returns the child object of the namespace.
###
Util.ns = (root, namespace) ->
  throw new Error('A namespace root must be specified') unless Object.isObject(root)

  # Check whether the NS has already been created.
  cached = cache[namespace]
  return cached if cached?

  # Build the namespace.
  result = Util.ns.get( root, namespace )

  # Finish up.
  cache[namespace] = result
  result




Util.ns.get = (root, namespace) ->
  return unless root? and namespace?

  if Object.isString(namespace)
    return if namespace.isBlank()

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
  add(root, namespace)


