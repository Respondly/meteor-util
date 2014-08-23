#= base
ns = Util.css ?= {}



###
Converts an array of values [left, top, right, bottom] to
an inline style string, eg: margin-left: 20px, margin-top: 20px etc.
@param prefix:  The style prefix (eg. 'padding' or 'margin')
@param values:  An array of values ordered as [left, top, right, bottom]
                If a number is provided the 'px' unit is used by default.
                If a string is provided the exact value is respected.
###
ns.spacingStyle = (prefix, values) ->
  format = (value) ->
    return value if Object.isString(value)
    value + 'px'

  result = ''
  append = (attr, value) ->
    return unless value?
    style = "#{ prefix }-#{ attr }:#{ format(value) }; "
    result += style

  append 'left',    values[0]
  append 'top',     values[1]
  append 'right',   values[2]
  append 'bottom',  values[3]

  result.trimRight()


###
Converts an array of values [left, top, right, bottom] to
an inline style string, eg: margin-left: 20px, margin-top: 20px etc.
@param values:  An array of values ordered as [left, top, right, bottom]
                If a number is provided the 'px' unit is used by default.
                If a string is provided the exact value is respected.
###
ns.marginStyle = (values) -> ns.spacingStyle 'margin', values


###
Converts an array of values [left, top, right, bottom] to
an inline style string, eg: padding-left: 20px, padding-top: 20px etc.
@param values:  An array of values ordered as [left, top, right, bottom]
                If a number is provided the 'px' unit is used by default.
                If a string is provided the exact value is respected.
###
ns.paddingStyle = (values) -> ns.spacingStyle 'padding', values


###
Strips the unit from a CSS style and returns it as a number.
@param value: The value, eg '24px'
@param unit:  Optional. The unit to strip.
###
ns.toNumber = (value, unit = 'px') ->
  if Object.isString(value) and value.endsWith(unit)
    value = value.remove(new RegExp("#{ unit }$")) # Strip the unit.
    value = value.toNumber()
  value


###
Extracts the number from the specified element style.
@param element: The JQuery element to examine.
@param style:   The style attribute (eg. 'left')
@param unit:    Optional. The unit to strip.
###
ns.styleAsNumber = (element, style, unit = 'px') -> ns.toNumber(element.css(style), unit)


