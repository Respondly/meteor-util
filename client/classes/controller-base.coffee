#= base


###
Base class for UI controllers.
###
class ControllerBase extends AutoRun
  constructor: ->
    super
    @hash = new ReactiveHash(onlyOnChange:true)
    Util.Events.extend(@)



  ###
  Disposes of the controller.
  ###
  dispose: ->
    super
    @hash?.dispose()
    @off()



  ###
  REACTIVE: Hash property.
  ###
  prop: (key, value, options) -> @hash.prop(key, value, options)


  ###
  Registers an auto-run function, automatically stopping the handler
  upon disposal.
  @param options:
          - runAfterLogout:   Flag indicating if functions should keep running after the user has logged out.
                              Default:false

          - disposeOnLogout:  Flag indicating if the controller should be disposed when the user logs out.
                              Default:true

  @param func: The function to execute.
  ###
  autorun: (options = {}, func) ->
    # Setup initial conditions.
    func = options if Object.isFunction(options)
    return unless Object.isFunction(func)
    runAfterLogout  = options.runAfterLogout ? false
    disposeOnLogout = options.disposeOnLogout ? true
    wasLoggedIn     = Meteor.userId()

    # Register the computation.
    super (computation) =>

      # Ensure the environment is still logged in before running.
      isLoggedIn = Meteor.userId()?

      if wasLoggedIn

        # Run the function if required.
        func(computation) if isLoggedIn or runAfterLogout

        # Dispose of the controller if logged out.
        @dispose() if not isLoggedIn and disposeOnLogout

      else
        # The user was not previously logged in, run as normal.
        func(computation)

      # Finish up.
      wasLoggedIn = isLoggedIn


