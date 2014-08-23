Meteor.startup ->

  # Source: http://stackoverflow.com/questions/12243898/how-to-select-all-text-in-contenteditable-div
  $.fn.selectText = ->
    el = this[0]

    if document.body.createTextRange?
      range = document.body.createTextRange()
      range.moveToElementText(el)
      range.select()

    else if window.getSelection?
      selection  = window.getSelection()
      range      = document.createRange()
      range.selectNodeContents(el)
      selection.removeAllRanges()
      selection.addRange(range)


  # Source: http://stackoverflow.com/questions/4233265/contenteditable-set-caret-at-the-end-of-the-text-cross-browser
  $.fn.caretAtEnd = ->
    el  = this[0]

    if window.getSelection? and document.createRange?
      range = document.createRange()
      range.selectNodeContents(el)
      range.collapse(false)
      sel = window.getSelection()
      sel.removeAllRanges()
      sel.addRange(range)

    else if document.body.createTextRange?
      range = document.body.createTextRange()
      range.moveToElementText(el)
      range.collapse(false)
      range.select()



  # Source: https://gist.github.com/661855
  ###
    jQuery Tiny Pub/Sub - v0.7 - 10/27/2011
    http://benalman.com/
    Copyright (c) 2011 "Cowboy" Ben Alman. Licensed MIT, GPL
  ###
  do ->
    o = $ {}
    $.subscribe   = -> o.on.apply(o, arguments)
    $.unsubscribe = -> o.off.apply(o, arguments)
    $.publish     = -> o.trigger.apply(o, arguments)



  # Source: http://techlister.com/tag/disable-select-all-using-jquery/
  $.fn.disableSelection = ->
      return this
      .attr('unselectable', 'on')
      .css('user-select', 'none')
      .css('-moz-user-select', 'none')
      .css('-khtml-user-select', 'none')
      .css('-webkit-user-select', 'none')
      .on('selectstart', false)
      .on('contextmenu', false)
      .on('keydown', false)
      .on('mousedown', false);
  $.fn.enableSelection = ->
      return this
      .attr('unselectable', '')
      .css('user-select', '')
      .css('-moz-user-select', '')
      .css('-khtml-user-select', '')
      .css('-webkit-user-select', '')
      .off('selectstart', false)
      .off('contextmenu', false)
      .off('keydown', false)
      .off('mousedown', false);



