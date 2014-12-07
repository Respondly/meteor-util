Meteor.startup ->

  ###
  Toggles the 'disabled' property on a INPUT element.
  @param isDisabled: Flag indicating if the "disabled" attribute should be applied.
  ###
  $.fn.toggleDisabled = (isDisabled) ->
    DISABLED = 'disabled'
    if isDisabled then this.attr(DISABLED, DISABLED) else this.removeAttr(DISABLED)


  ###
  Determines whether the element is a text INPUT editor of some kind.
  ###
  $.fn.isTextInput = ->
    el = this[0]
    if tag = el.tagName
      return true if tag is 'INPUT'
      return true if tag is 'TEXTAREA'
    return true if el.contentEditable is 'true'
    false



  ###
  Finds the first parent that allows vertical scrolling.
  ###
  $.fn.scrollParentY = ->
    walk = (el) ->
        return if el.length is 0
        parent = el.parent()
        return if not parent[0]?
        return if parent[0]?.nodeName is '#document'

        position  = parent.css('position')
        overflowY = parent.css('overflow-y')
        return parent if (position is 'absolute' or position is 'relative') and overflowY is 'auto'
        return parent if Util.isTrue(parent.attr('data-scroll-parent'))

        walk(parent) # <== RECURSION.

    walk(@)



  ###
  Determines whether the element is currently focused.
  ###
  $.fn.hasFocus = ->
    document.activeElement is this[0]

