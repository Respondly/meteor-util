MODIFIERS =
  ALT:         17
  CTRL:        18
  META_LEFT:   91
  META_RIGHT:  93


Meteor.startup ->
  Util.keyboard = new Keyboard()


hash = new ReactiveHash()


###
Global keyboard event bus.
###
class Keyboard
  constructor: ->
    keyDownHandlers = new Handlers()
    keyUpHandlers   = new Handlers()

    @__internal__ =
      keyDownHandlers: keyDownHandlers
      keyUpHandlers: keyUpHandlers

    handleKeyDown = (e) =>
        current = @current() ? {}
        modifiers = @modifiers() ? {}
        if e
          # Store the current key.
          current[e.which] = e
          @current(current)

          # Store as a modifier (if it is one).
          if modifierKey = toModifierKey(e)
            modifiers[modifierKey] = e
            @modifiers(modifiers)

          # Invoke handlers.
          keyDownHandlers.invoke(e)



    handleKeyUp = (e) =>
        if e.isMeta()
          @reset()
        else
          # Reset the key.
          if current = @current()
            delete current[e.which]
            @current(current)

          # Reset the modifier (if it is one).
          if modifierKey = toModifierKey(e)
            modifiers = @modifiers()
            delete modifiers[modifierKey]
            @modifiers(modifiers)

          # Invoke handlers.
          keyUpHandlers.invoke(e)

    $(document).keydown  (e) => handleKeyDown(Util.keys.toArgs(e))
    $(document).keyup    (e) => handleKeyUp(Util.keys.toArgs(e))
    $(window).on 'blur', (e) => @reset()



  ###
  Resets the state of the control.
  ###
  reset: ->
    @current({})
    @modifiers({})



  ###
  REACTIVE: An object containing the currently pressed keys.
  ###
  current: (value) -> hash.prop 'current', value, default:{}



  ###
  REACTIVE: An object containing the currently pressed modifier keys.
  ###
  modifiers: (value) -> hash.prop 'modifiers', value, default:{}



  ###
  REACTIVE: Determines whether the modifier key is pressed.
  ###
  isModifierPressed: -> not Object.isEmpty(@modifiers())



  ###
  Registers a handler to invoke when a key is pressed.
  @param func(e): The function to invoke with the event args.
  @returns the handle. Use the [stop] method to release.
  ###
  keyDown: (func) -> @__internal__.keyDownHandlers.push(func)



  ###
  Registers a handler to invoke when a key is released.
  @param func(e): The function to invoke with the event args.
  @returns the handle. Use the [stop] method to release.
  ###
  keyUp: (func) -> @__internal__.keyUpHandlers.push(func)




# PRIVATE ----------------------------------------------------------------------


toModifierKey = (e) ->
  switch e.which
    when MODIFIERS.ALT then 'alt'
    when MODIFIERS.CTRL then 'ctrl'
    when MODIFIERS.META_LEFT, MODIFIERS.META_RIGHT then 'meta'



