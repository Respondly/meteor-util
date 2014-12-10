###
A hash/dictionary that is reactive, but does not persist
values across hot-code-pushes.
###
class ReactiveHash
  ###
  Constructor.
  @param options:
            - onlyOnChange: The default [onlyOnChange] value.
  ###
  constructor: (options = {}) ->
    keyDeps = {}
    equalityDeps = {}

    @__internal__ =
      keyDeps: keyDeps
      equalityDeps: equalityDeps

      ensureKeyDeps: (key) ->
          # Used by [get/set/prop].
          keyDeps[key] = new Tracker.Dependency() unless keyDeps[key]
          keyDeps[key]

      ensureEqualityDeps: (key) ->
          # Used by [equals].
          equalityDeps[key] ?= {}

    @keys = {}
    @onlyOnChange = options.onlyOnChange ? false


  ###
  Disposes of the hash.
  ###
  dispose: ->
    @isDisposed = true
    @keys = {}
    @__internal__ = {}



  ###
  Default setting for the 'onlyOnChange' option passed to the [prop] method.
  ###
  onlyOnChange: false



  ###
  REACTIVE: Gets the value at the given key.
  @param key: The unique identifier of the value (this is prefixed with the namespace).
  ###
  get: (key) =>
    return if @isDisposed
    @__internal__.ensureKeyDeps(key).depend()
    @keys[key]



  ###
  Sets the given value
  @param key:   The unique identifier of the value.
  @param value: The value to set (pass nothing/undefined to remove).
  @param options:
            onlyOnChange:  (optional). Will only call set if the value has changed.
                                           Default is set by the [defaultOnlySetIfChanged] property.
  ###
  set: (key, value, options = {}) =>
    return if @isDisposed

    # Don't set if the value hasn't changed (and this check is specified)
    onlyOnChange = if options.onlyOnChange? then options.onlyOnChange else @onlyOnChange
    if onlyOnChange and Object.equal(value, @keys[key])
      return value

    # Store a reference to the value.
    if value is undefined then delete @keys[key] else @keys[key] = value

    # Signal change to [get/prop] dependencies.
    @__internal__.ensureKeyDeps(key).changed()

    # Signal a change if an [equals] dependency has been setup.
    if canSerialize(value)
      if ref = @__internal__.equalityDeps[key]
        hashKey = toHashKey(value)
        isEqual = Object.equal(ref.value[hashKey], value)
        ref.dependency.changed() if isEqual isnt ref.isEqual
        ref.isEqual = isEqual

    # Finish up.
    value


  ###
  Removes the value with the given key.
  Same as calling 'set' with undefined.
  @param key:   The unique identifier of the value (this is prefixed with the namespace).
  ###
  unset: (key) => @set(key, undefined)


  ###
  Remove all values from the session object.
  ###
  clear: -> @unset(key) for key of @keys



  ###
  REACTIVE: Gets or sets the value for the given key.
  @param key:         The unique identifier of the value (this is prefixed with the namespace).
  @param value:       (optional). The value to set (pass null to remove).
  @param options:
            default:  (optional). The default value to return if the session does not contain the value (ie. undefined).
            onlyOnChange:  (optional). Will only call set if the value has changed.
                                           Default is set by the [defaultOnlySetIfChanged] property.
  ###
  prop: (key, value, options = {}) ->
    if value isnt undefined
      # WRITE.
      @set(key, value, options)
    else
      # READ ONLY.
      value = @get(key)
      value = options.default if value is undefined

    value



  ###
  Checks for equality and only re-runs dependencies if the value
  has changed.

  ###
  equals: (key, value) ->
    return if @isDisposed

    # Don't allow objects as they cannot be serialized as a key.
    if not canSerialize(value)
      throw new Error('ReactiveHash.equals: value must be scalar')


    # Get the dependency model.
    hashKey = toHashKey(value)
    ref = @__internal__.ensureEqualityDeps(key)

    # - First time call, initialize the dependency reference.
    if Object.isEmpty(ref)
      isNew = true
      ref.dependency = new Tracker.Dependency()

      # Prevent memory lead: Remove references when there are no
      # longer any dependent functions.
      Tracker.onInvalidate =>
          Tracker.afterFlush =>
            unless ref.dependency.hasDependents()
              delete @__internal__.equalityDeps[key]

    # Store the requested value.
    ref.value ?= {}
    ref.value[hashKey] = value
    ref.dependency.depend()

    # Calculate initial equality.
    # NOTE: Future checks (and change signalling) occurs
    #       within the [set] method.
    currentValue = Tracker.nonreactive => @get(key)
    isEqual = ref.isEqual = Object.equal(value, currentValue)

    # Finish up.
    isNew = false
    isEqual



# PRIVATE ----------------------------------------------------------------------



# [Mongo.ObjectID] is in the 'mongo' package.
ObjectID = null
ObjectID = Mongo.ObjectID if Mongo?

canSerialize = (value) ->
    return true if not value?
    return true if Object.isString(value)
    return true if Object.isNumber(value)
    return true if Object.isBoolean(value)
    return true if Object.isDate(value)
    if ObjectID
      return true if (value instanceof ObjectID)
    false


toHashKey = (value) ->
  return undefined if value is undefined
  EJSON.stringify(value)



