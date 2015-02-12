###
Provides a 'dispose' method and a way of registering
handlers for cleaning up an object at time of destruction.
###
Stamps.Disposable = stampit().enclose ->
  handlers = null


  ###
  Disposes of the object.
  ###
  @dispose = ->
    return if @isDisposed

    if handlers
      handlers.invoke()
      handlers.dispose()

    @isDisposed = true


  ###
  Registers a handler to run when disposed.
  @param func: The dispose ahdnler to run.
  ###
  @onDisposed = (func) ->
    handlers ?= new Handlers(@)
    handlers.push(func)



  # ----------------------------------------------------------------------
  return @
