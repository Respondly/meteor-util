### @export ReactiveHash ###




###
Provides a way of accessing the Session object
within a scoped namespace.
###
class ScopedSession

  ###
  Constructor.
  @param namespace: The namespace within which to scope the session values.
  ###
  constructor: (@namespace) ->
    throw new Error('No namespace') if Util.isBlank(@namespace)
    throw new Error("Scoped session [#{@namespace}] already exists.") if instances[@namespace]?
    # @_keys = {}
    instances[@namespace] = @


  ###
  Destroyes the session instance.
  ###
  dispose: ->
    delete instances[@namespace]
    @clear()
    @isDisposed = true



  ###
  Gets the value at the given key.
  @param key: The unique identifier of the value (this is prefixed with the namespace).
  ###
  get: (key) -> Session.get(scopedKey(@, key))


  ###
  Sets the given value
  @param key:   The unique identifier of the value (this is prefixed with the namespace).
  @param value: The value to set (pass nothing/undefined to remove).
  ###
  set: (key, value) =>
    return if @isDisposed # Don't write more values onto a disposed session.

    # Store the value.
    key = scopedKey(@, key)
    Session.set(key, value)

    # Clean up global Session object if [undefined].
    if value is undefined
      delete Session.keys[key]
      delete Session.keyDeps[key]
      delete Session.keyValueDeps[key]

    # Finish up.
    value


  ###
  Removes the value with the given key.
  Same as calling 'set' with undefined.
  @param key:   The unique identifier of the value (this is prefixed with the namespace).
  ###
  unset: (key) => @set( key, undefined )


  ###
  Retrieves the collection of keys.
  ###
  keys: ->
    keys = []
    for key, value of Session.keys
      if key.startsWith(@namespace)
        keys.push(key.substring(@namespace.length + 1, key.length))
    keys



  ###
  Remove all values from the session object.
  ###
  clear: -> @unset(key) for key in @keys()




# CLASS METHODS ----------------------------------------------------------------------



ScopedSession.instances = instances = {}





# PRIVATE ----------------------------------------------------------------------


scopedKey = (session, key) -> "#{ session.namespace }:#{ key }"
