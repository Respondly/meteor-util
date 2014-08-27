EDGES = ['left', 'top', 'right', 'bottom']
VENDOR_PREFIXES = ['-webkit-', '-moz-', '-o-', '-ms-', '']


Meteor.startup ->
  # Expose as jQuery extension.
  $.fn.style = -> new Style(this)
  $.fn.opacity = (value) -> this.style().opacity(value)
  $.fn.isVisible = (value) -> this.style().isVisible(value)



###
Style utility returned via jQuery extension.
###
class Style
  constructor: (@el) ->

  ###
  The padding as an object.
  ###
  padding: (value) -> spacingProperty(@el, 'padding', value)


  ###
  The margin as an object.
  ###
  margin: (value) -> spacingProperty(@el, 'margin', value)


  ###
  Creates an { width|height } size representation of the element.
  ###
  size: (value...) ->
    if value.length > 0
      value = Util.toSize(value)
      @width(value.width)
      @height(value.height)
    { width:@el.outerWidth(), height:@el.outerHeight() }


  ###
  Creates an { left|top|width|height } size representation of the element.
  ###
  rect: ->
    rect = @size()
    rect.left = @left()
    rect.top = @top()
    rect


  ###
  Produces a { left|top|width|height } representation of the element.
  ###
  toRect: (left = 0, top = left) ->
    size = @size()
    size.left = left
    size.top = top
    size


  ###
  Gets whether the element is currently visible.
  @param value: Optional.  Boolean used when writing.
  ###
  isVisible: (value) ->
    # Write.
    if Object.isBoolean(value)
      @el.css 'visibility', if value then 'visible' else 'hidden'
      @el.toggle(true) if value is true

    # Read.
    return false if not @el.is(":visible")
    return false if @el.css('visibility') is 'hidden'
    true


  ###
  Gets or sets the CSS opacity of the element.

      WARNING: Writing with this method will destroy any
               non-related 'filter' styles on the element.

  @param value: Optional. The percent to write [0..1]. Ommit to read only =.
  ###
  opacity: (value) ->
    # Write.
    if value isnt undefined
      value = 0 if value < 0
      value = 1 if value > 1
      @replace  "opacity: #{ value }",
                "filter: #{ value * 100 }",
                "-ms-filter: \"progid:DXImageTransform.Microsoft.Alpha(Opacity=#{ value * 100 })\""

    # Read.
    if result = @el.css('opacity')
      result.toNumber().round(2)



  ###
  Gets or sets a transform on the element.

      WARNING: Writing with this method will destroy any
               non-related 'transform' styles on the element.

  @param value: Specify when writing.
                An object containing transform values.
                  {
                    rotate:30
                    translate:'10px,-20px'
                    scale:'2,4'
                    skew:'30deg, 20deg'
                    matrix...
                  }
  ###
  transform: (value) ->
    # Write.
    if value isnt undefined
      value = {} if value is null
      transforms = ''
      for own key, transformValue of value
        transforms += "#{ key }(#{ transformValue }) "
      styles = vendor('transform', transforms.trim())
      @replace(styles)

    # Read.
    value = @el.css('transform')
    value = null if value is 'none'
    value



  ###
  Gets or sets the transition on the element.
  @param value: The transition value, for example: 'opacity 0.3s'
  ###
  transition: (value) -> @vendorProp('transition', value)



  ###
  Creates a new 'style' attribute value for the element,
  replace or adding the given styles.
  @param styles: An array of [style:value] key pairs.
  @returns the updated style.
  ###
  replace: (styles...) ->
    # Setup initial conditions.
    styles = styles.flatten()
    elementStyle = @el.attr('style') ? ''
    attributes = styles.map (style) -> style.split(':')[0]

    # Remove any existing styles that have been given.
    parts = elementStyle.split(';').map (style) -> style.trim().remove /;$/
    parts = parts.remove (style) ->
                style = style.trim()
                return true if Util.isBlank(style)
                for attr in attributes
                  return true if style.startsWith(attr)

    # Add the given styles.
    for style in styles
      style = style.trim().remove /;$/
      parts.push(style)
    @el.attr 'style', parts.join('; ')

    # Finish up.
    @el.attr('style')



  ###
  Gets or sets the top style.
  @param value: Optional.  When setting the value.
  @param options:
            - unit: Default:'px'
  ###
  top: (value, options = {}) ->
    options.unit ?= 'px'
    @prop('top', value, options)

  ###
  Gets or sets the left style.
  @param value: Optional.  When setting the value.
  @param options:
            - unit: Default:'px'
  ###
  left: (value, options = {}) ->
    options.unit ?= 'px'
    @prop('left', value, options)

  ###
  Gets or sets the right style.
  @param value: Optional.  When setting the value.
  @param options:
            - unit: Default:'px'
  ###
  right: (value, options = {}) ->
    options.unit ?= 'px'
    @prop('right', value, options)

  ###
  Gets or sets the bottom style.
  @param value: Optional.  When setting the value.
  @param options:
            - unit: Default:'px'
  ###
  bottom: (value, options = {}) ->
    options.unit ?= 'px'
    @prop('bottom', value, options)



  ###
  Gets or sets the width style.
  @param value: Optional.  When setting the value.
  @param options:
            - unit: Default:'px'
  ###
  width: (value, options = {}) ->
    options.unit ?= 'px'
    @prop('width', value, options)

  ###
  Gets or sets the height style.
  @param value: Optional.  When setting the value.
  @param options:
            - unit: Default:'px'
  ###
  height: (value, options = {}) ->
    options.unit ?= 'px'
    @prop('height', value, options)


  ###
  Gets or sets the max-width style.
  @param value: Optional.  When setting the value.
  @param options:
            - unit: Default:'px'
  ###
  maxWidth: (value, options = {}) ->
    options.unit ?= 'px'
    @prop('max-width', value, options)

  ###
  Gets or sets the max-height style.
  @param value: Optional.  When setting the value.
  @param options:
            - unit: Default:'px'
  ###
  maxHeight: (value, options = {}) ->
    options.unit ?= 'px'
    @prop('max-height', value, options)




  ###
  Allows property style read/write operations on CSS values.
  Example:

    maxWidth: (value) -> @css 'max-width', value, unit:'px'

    isVisible: (value) ->
      @css 'display', value,
        onRead: (value) -> value is 'block'
        onWrite: (value) -> if value then 'block' else 'none'


  @param style:     The CSS style under consideration.
  @param value:     Optional.  The CSS value to write.
                    Ommit for read operations.
                    Pass null or empty-string ('') to remove the CSS property.
  @param options:
            - unit:            Optional.  The value's unit, eg 'px'.
            - onRead(value):   Optional.  A function that transforms the value upon reading.
            - onWrite(value):  Optional.  A function that transforms the value upon reading.

  @returns The CSS value, or null if the value does not exist.
  ###
  prop: (style, value, options = {}) ->
    # Setup initial conditions.
    unit    = options.unit
    onRead  = options.onRead
    onWrite = options.onWrite

    # Write.
    if value isnt undefined
      value = onWrite(value) if Object.isFunction(onWrite)
      value = '' if value is null or value is undefined
      write = value
      write += unit if value? and unit and Object.isNumber(value)
      @el.css(style, write)

    # Read.
    result = @el?.css(style)
    if result and unit
      result = Util.css.toNumber(result, unit)
    result = result ? null
    result = onRead(result) if Object.isFunction(onRead)

    # Finish up.
    result


  ###
  Allows property style read/write operations on CSS values with vendor attributes.
  @param style:     The CSS style under consideration.
  @param value:     Optional.  The CSS value to write.
                    Ommit for read operations.
                    Pass null or empty-string ('') to remove the CSS property.

  ###
  vendorProp: (style, value) ->
    # Write
    if value isnt undefined
      if value is null
        style = ''
      else
        style = vendor(style, value)
      @replace(style)

    # Read.
    value = @el.css(style)
    value = null if value is 'none'
    value





# PRIVATE --------------------------------------------------------------------------



spacingProperty = (el, style, value) ->
  # Write.
  if value isnt undefined
    if Object.isString(value)
      el.css(style, value) # Write as string.
    if Util.isObject(value)
      for edge in EDGES
        el.css("#{ style }-#{ edge }", value[edge] + 'px')

  # Read.
  result = { value: el.css(style) }
  for edge in EDGES
    result[edge] = Util.css.toNumber(el.css("#{ style }-#{ edge }"))
  result



vendor = (attr, value) ->
  result = []
  for prefix in VENDOR_PREFIXES
    result.push "#{ prefix }#{ attr }:#{ value };"
  result







