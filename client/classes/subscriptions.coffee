###
Manages a set of subscriptions.
###
class Util.Subscriptions
  constructor: ->
    @_ = {}



  ###
  Disposes of the subscription manager and stops all active subscriptions.
  ###
  dispose: ->
    @stop()
    @_ = {}
    @isDisposed = true



  ###
  Gets the set of subscriptions with the given name.
  @param name: Subscription name.
  @param args: (optional) The arguments passed to the subscription.
  ###
  find: (name, args...) ->
    args = args.flatten()
    if result = @_[name]
      if args.length > 0
        for item in result
          return item if Object.equal(item.args, args)



  ###
  Starts a subscription if it has not already been started with the same
  parameters (not including callbacks).

  @param name:      The name of the subscription.
  @param args:      (optional) The arguments passed to the subscription.
  @param callback:  (optional) A function to invoke upon completion, or an { onReady | onError } object.

  @returns the subscription object.
  ###
  singleton: (args...) ->
    # Setup initial conditions.`
    args = formatArgs(args)
    name = args.name

    # Determine if the subscription has already been established.
    if existing = @find(name, args.args)

      # Store unique callbacks.
      for callback in args.callbacks
        alreadyExists = existing.callbacks.any (fn) -> Object.equal(fn, callback)
        unless alreadyExists
          existing.callbacks.push(callback)

      # Return the existing subscription.
      return existing
    else
      # Invoke and store the subscription.
      callback =
        onReady:       -> args.callbacks.each (callback) -> callback.onReady?()
        onError: (err) -> args.callbacks.each (callback) -> callback.onError?(err)
      params = args.toArray().add(callback)

      subscription = Meteor.subscribe.apply(@, params)
      @_[name] ?= []
      @_[name].push(args)

      # Assign stop and ready functions.
      args.ready = -> subscription.ready()
      args.stop = =>
              subscription.stop()
              delete @_[name]
              true # Stopped.

      # Finish up.
      return args



  ###
  Stops all subscriptions with the given name.
  @param name:  (optional) The name or the subscription to stop.
                Pass nothing to stop all subscriptions.
  @returns True if the subscription existed, and was stopped, otherwise False.
  ###
  stop: (name) ->
    if not name
      @stop(key) for key, value of @_
      return

    if subscription = @_[name]
      item.stop() for item in subscription
      true
    else
      false



# PRIVATE --------------------------------------------------------------------------



formatArgs = (args...) ->
  args = args.flatten()
  name = args[0]
  args.removeAt(0)

  # Extract the callback.
  last = args.last()
  if Object.isFunction(last)
    callback = { onReady:last }
    args.removeAt(args.length - 1)

  else if Object.isObject(last)
    if Object.isFunction(last.onReady) or Object.isFunction(last.onError)
      callback = last
      args.removeAt(args.length - 1)

  result =
    name: name
    args: args
    callbacks: [ callback ].compact()
    toArray: -> [name, args].flatten()

