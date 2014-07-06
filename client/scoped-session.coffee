### @export ReactiveHash ###


console.log 'Session.keys', Session.keys



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
    # Ensure a namespace exists.
    throw new Error('No namespace') if Util.isBlank(@namespace)

    # Prefix with the [ScopedNamespace] identifier.
    @namespace = "__#{ @namespace }"
    throw new Error("Scoped session [#{@namespace}] already exists.") if instances[@namespace]?

    # Store singleton instance.
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



  ###
  Gets or sets the value for the given key.
  @param key:         The unique identifier of the value (this is prefixed with the namespace).
  @param value:       (optional). The value to set (pass null to remove).
  @param options:
            default:  (optional). The default value to return if the session does not contain the value (ie. undefined).
  ###
  prop: (key, value, options = {}) ->
    if value isnt undefined
      # Write.
      @set(key, value)
      return value
    else
      # Read only.
      value = @get(key)
      return if value isnt undefined then value else options.default




# CLASS METHODS ----------------------------------------------------------------------



ScopedSession.instances = instances = {}


###
Gets the session object with the given namespace, or creates
a new instance of it if it does not already exist.

@param namespace: The namespace of the session to retrieve.
###
ScopedSession.singleton = (namespace) ->
  instances[namespace] = new ScopedSession(namespace) unless instances[namespace]?
  instances[namespace]



###
Disposes of all scoped sessions.
###
ScopedSession.reset = -> instance.dispose() for key, instance of instances




# PRIVATE ----------------------------------------------------------------------


scopedKey = (session, key) -> "#{ session.namespace }:#{ key }"
