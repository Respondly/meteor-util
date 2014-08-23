#= base


###
Base class containing functionality for handling [Deps.autorun].
###
class AutoRun
  constructor: ->
    @__internal__ ?= {}
    @__internal__.depsHandles = []



  ###
  Disposes of the controller.
  ###
  dispose: ->
    @isDisposed = true
    depsHandles = @__internal__.depsHandles
    depsHandles?.each (handle) -> handle?.stop()
    delete @__internal__.depsHandles



  ###
  Registers an auto-run function, automatically stopping
  the handler upon disposal.
  @param func: The function to execute.
  @returns the auto-run handler.
  ###
  autorun: (func) ->
    return if @isDisposed
    if Object.isFunction(func)
      handle = Deps.autorun (computation) -> func(computation)
      @__internal__.depsHandles.push(handle)
      handle

