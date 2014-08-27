ns = Util.keys ?= {}
KEYS = Const.KEYS


###
Determines whether the key produces content.
Keys that this excludes are:
  - cursor keys
  - home/end
  - delete/backspace keys.
  - keys hit while the meta (CMD) key is depressed.
###
ns.isContentKey = (e) ->
  return false if e.metaKey
  switch e.which
    when KEYS.UP, KEYS.DOWN, KEYS.LEFT, KEYS.RIGHT then false # Cursor.
    when KEYS.HOME, KEYS.END then false # Home/End.
    when KEYS.DELETE, KEYS.BACK_SPACE then false # Deletion.
    when KEYS.TAB, KEYS.ESC then false
    else
      true



###
Convert a key-code to it's corresponding character-number.
@param keyCode: The key-code to convert.
###
ns.toNumber = (keyCode) ->
  keyCode = parseInt(keyCode)
  return keyCode - 48 if ( 48 <= keyCode <= 57 )
  return keyCode - 96 if ( 96 <= keyCode <= 105 )


###
Determines whether the given key-code is a number key.
@param keyCode: The key-code to examine.
###
ns.isNumber = (keyCode) -> Object.isNumber(ns.toNumber(keyCode))


###
Determines whether the given key-code is ALT, CTRL, SHIFT, META
@param keyCode: The key-code to examine.
###
ns.isModifier = (keyCode) ->
  switch keyCode
    when KEYS.SHIFT, KEYS.ALT, KEYS.CTRL, KEYS.META_LEFT, KEYS.META_RIGHT then true
    else
      false


###
Determines whether the given key-code is a META key.
@param keyCode: The key-code to examine.
###
ns.isMeta = (keyCode) ->
  switch keyCode
    when KEYS.META_LEFT, KEYS.META_RIGHT then true
    else
      false





###
Creates a wrapper to standard keyboard args.
@param e: The raw key event.
###
ns.toArgs = (e) ->
  keyCode = e.which

  flags = {}
  for key, value of KEYS
    key = key.camelize(false)
    flags[key] = (value is keyCode)

  args =
    e:        e
    time:     new Date()
    keyCode:  keyCode
    which:    keyCode
    meta:     e.metaKey
    ctrl:     e.ctrlKey
    alt:      e.altKey
    shift:    e.shiftKey
    is:       flags
    isNumber: -> ns.isNumber(keyCode)
    toNumber: -> ns.toNumber(keyCode)
    isMeta: -> ns.isMeta(keyCode)
    isModifier: -> ns.isModifier(keyCode)
    hasModifier: -> not @isModifier() and (@meta or @ctrl or @alt or @shift)
    isContentKey: -> ns.isContentKey(e)
    preventDefault: -> e.preventDefault()
    handled: ->
      args.preventDefault()
      args.isHandled = true




