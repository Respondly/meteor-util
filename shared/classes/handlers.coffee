###
Represents a collection of handler functions.
###
class Handlers
  ###
  Constructor.
  @param context: The [this] context within which to invoke the handlers.
  @param handlers: An array of functions to add.
  ###
  constructor: (@context, handlers...) ->
    @items = []
    @push(func) for func in handlers.flatten()


  dispose: ->
    @clear()
    @isDisposed = true


  ###
  Gets the number of registered handlers.
  ###
  count: -> @items.length

  ###
  Gets whether the collection contains the given handler function.
  ###
  contains: (func) -> @handle(func)?


  ###
  Gets the handle with the corresponding function.
  ###
  handle: (func) -> @items.find (item) -> item.func is func


  ###
  Adds a function to the collection.
  @param func: The handler function.
  @returns A handle object.  Use "stop()" to clear remove it.
  ###
  add: (func) ->
    if Object.isFunction(func)
      handle = createHandle(@, func)
      @items.push(handle)
      handle

  # Alias to 'add'.
  push: (func) -> @add(func)


  ###
  Adds a function from the collection.
  @param func: The handler function to remove.
  @returns true if the function was removed, or false if it was not found.
  ###
  remove: (func) ->
    handle = @items.find (item) -> item.func is func
    @items.remove(handle) if handle
    handle?


  ###
  Removes all functions from the collection.
  ###
  clear: ->
    @items = []


  ###
  Invokes all handlers within the collection.
  @param args: Optional. The arguments to pass.
  @returns false if any handler returned false (ie. cancelled the operation in question).
  ###
  invoke: (args...) ->
    for item in @items.clone()
      result = Deps.nonreactive => item.func.apply(@context, args)
      return false if result is false
    true


  ###
  Invokes handlers returning the first non-[null/undefined] returned by a handler.
  @param args: Optional. The arguments to pass.
  @returns the first handler result, or undefined.
  ###
  firstResult: (args...) ->
    for item in @items.clone()
      result = Deps.nonreactive => item.func.apply(@context, args)
      return result if result?


  ###
  Invokes all handlers returning an array of all results.
  @param args: Optional. The arguments to pass.
  @returns the resulting array of results (including undefined/null values).
  ###
  results: (args...) ->
    results = []
    for item in @items.clone()
      result = Deps.nonreactive => item.func.apply(@context, args)
      results.push(result)
    results


  ###
  Invokes all handlers asynchronously.
  @param args: Optional. The arguments to pass.
  @param callback(result): Invoked upon completion.
                           - result: false if any handler returned false (ie. cancelled the operation in question).
  ###
  invokeAsync: (args..., callback) ->
    if @items.length is 0
      callback(true)
      return

    isCancelled = false
    count = 0
    done = (result) =>
        count += 1
        unless isCancelled
          isCancelled = true if result is false
          if isCancelled
            callback(false)
          else if count is @items.length
            callback(true)

    args.push(done)
    for item in @items.clone()
      Deps.nonreactive =>
        item.func.apply(@context, args)




# PRIVATE --------------------------------------------------------------------------



createHandle = (handlers, func) ->
  handle =
    handlers: handlers
    func: func
    isStopped: false
    stop: ->
      return if handle.isStopped is true
      handle.isStopped = true
      handlers.items.removeAt(handlers.items.indexOf(handle))

    dispose: -> @stop()



