MODIFIERS =
  ALT:         17
  CTRL:        18
  META_LEFT:   91
  META_RIGHT:  93


Meteor.startup ->
  Util.keyboard = new Keyboard()



hash = new ReactiveHash()

class Keyboard # extends KeyboardController
  constructor: ->
    $(document).keydown  (e) => @onKeyDown(Util.keys.toArgs(e))
    $(document).keyup    (e) => @onKeyUp(Util.keys.toArgs(e))
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


  # OVERRIDES ----------------------------------------------------------------------


  onKeyDown: (e) ->
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





  onKeyUp: (e) ->
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
        # modifiers[modifierKey] = e
        @modifiers(modifiers)


# PRIVATE ----------------------------------------------------------------------


toModifierKey = (e) ->
  switch e.which
    when MODIFIERS.ALT then 'alt'
    when MODIFIERS.CTRL then 'ctrl'
    when MODIFIERS.META_LEFT, MODIFIERS.META_RIGHT then 'meta'



