###
Base class for UI controllers.
###
class KeyboardController extends ControllerBase
  constructor: ->
    super
    @_keyDownHandlers = new Handlers()
    lastArgs = null

    $(document).keydown (e) =>
      # Setup initial conditions.
      return if @isDisposed
      args = Util.keys.toArgs(e)
      args.self = @

      # Ensure the key-event is only propogated once.
      #   This provides a consistent "single key" event experience, avoiding a stream of
      #   follow-on events that occur if a key is held down for a sustained period.
      if lastArgs?
        lastArgs.count += 1 if e.keyCode is lastArgs.keyCode

        if lastArgs.count > 1
          # This is a follow-on key event that occurs when a key is held down.
          # Don't run the keydown handlers.
          return

      # NOTE: There is an issue with this where the META (CMD) key does not register keyup events
      #       while the CMD key is depressed. It's unclear how to work around this.
      #       The outcome of this is that the first CMD+<key> combination will run the handlers
      #       but keys pressed after that will not register, until the CMD key is released.

      # Invoke handlers.
      if @_keyDownHandlers.invoke(args) isnt false
        @onKeyDown(args)

      # Finish up.
      lastArgs = args
      lastArgs.count = 1


    $(document).keyup (e) =>
      if lastArgs and (not Util.keys.isModifier(e.keyCode) or Util.keys.isMeta(e.keyCode))
        lastArgs = null



  ###
  Destroys the keyboard controller.
  ###
  dispose: ->
    super
    @_keyDownHandlers.dispose()



  ###
  OVERRIDABLE: Invoked when a key is pressed.
  @param e: The key event args
  ###
  onKeyDown: (args) -> # No-op.



  ###
  Registers a function to invoke before the [onKeyDown] handler is run.
  @param func(args): The function to add.
  ###
  keyDown: (func) -> @_keyDownHandlers.push(func)




  ###
  OVERRIDABLE:  Determines whether an INPUT element currently has focus.
                This includes things like <INPUT> of CONTENTEDITABLE elements.
  @returns Boolean.
  ###
  isInputFocused: ->
    if activeElement = document.activeElement
      return true if $(activeElement).isTextInput()
    false


