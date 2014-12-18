###
Provides a safe way to start an auto-run.
Call @autorun.stop() to stop all registered handlers.
###
Stamps.AutoRun = stampit().enclose ->
  ###
  Registers an auto-run function.
  @param func: The function to execute.
  @returns the auto-run handler.
  ###
  @autorun = (func) ->
    if Object.isFunction(func)
      handle = Deps.autorun (computation) -> func(computation)
      @autorun.handles.push(handle)
      handle


  ###
  The collection of auto-run handles.
  ###
  @autorun.handles = []


  ###
  Stops all registered handles.
  ###
  @autorun.stop = => @autorun.dispose()
  @autorun.dispose = =>
    handles = @autorun.handles
    handles?.each (handle) -> handle?.stop()
    @autorun.handles = []
    @


  # Hook into [onDisposed] callback if it's been
  # composed into the object.
  # See: [Stamps.Disposable]
  @onDisposed? =>
    @autorun.dispose()




  # ----------------------------------------------------------------------
  return @