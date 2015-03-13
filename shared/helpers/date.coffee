# See also the Date functions in Sugar.js
# http://sugarjs.com/api
ns = Util.date = {}


SECOND  = 1
MINUTE  = SECOND * 60
HOUR    = MINUTE * 60
DAY     = HOUR * 24
YEAR    = DAY * 365


###
Formats a date into an readable elapsed time, eg:

    - just now
    - 2 minutes
    - 1 hour
    - 3 days

  To include the 'ago' suffix, call the method like this, and use the [display] property:

      formatElapsed( date, asParts:true ).display

  @param date:        The [Date] to format,
                      or the total seconds (number).

  @param options:
            asParts:  Flag indicating if the result should be returned
                      as parts ({ value:'2.45', unit:'hours' })
                      Default: false.

            from:     (optional) The date the elapsed time is being calculated "from".
                       If ommited the current Date/Time is used.

            format:   Flag indicating how long the units should be
                      Values:
                       - long (eg. 'day') - default
                       - short (eg 'd')

            justNow:  Flag indicating if "just now" should be returned for values
                      less than a minute old.
                      Default: true

###
ns.formatElapsed = (date, options = {}) ->
  return unless date?

  # Setup initial conditions.
  plural      = Util.string.plural
  unit        = ''
  format      = options.format ? 'long'
  justNow     = options.justNow ? true

  if Object.isDate(date)
    fromDate    = options.from ? new Date()
    secondsAgo  = Math.round((fromDate - date) / 1000)

  else if Object.isNumber(date)
    secondsAgo = date

  else
    throw new Error("Date type not supported: #{ date }")


  switch ns.elapsedUnit(secondsAgo)
    when 'second'
      value = secondsAgo.round(0)
      unit  = switch format
                when 'short' then 's'
                else plural(value, 'second')

      abbreviation = switch format
                        when 'short' then 'now'
                        else 'just now'

    when 'minute'
      value = (secondsAgo / MINUTE).round(0)
      unit  = switch format
                when 'short' then 'm'
                else plural(value, 'minute')

    when 'hour'
      value = (secondsAgo / HOUR).round(0)
      unit  = switch format
                when 'short' then 'h'
                else plural(value, 'hour')

    when 'day'
      value = (secondsAgo / DAY).round(0)
      unit  = switch format
                when 'short' then 'd'
                else plural(value, 'day')

    when 'year'
      value = (secondsAgo / YEAR).round(0)
      unit  = switch format
                when 'short' then 'y'
                else plural(value, 'year')

  # Format response.
  valueUnit = switch format
                when 'short' then value + unit
                else "#{ value } #{ unit ? '' }".trim()

  if options.asParts is true
    result =
      value: value
      valueUnit: valueUnit

    if unit isnt ''
      result.unit   = unit
      result.suffix = 'ago'
    result.display = if (abbreviation and justNow) then abbreviation else "#{ valueUnit } #{ result.suffix ? '' }".trim()
    return result
  else
    return if secondsAgo < MINUTE then abbreviation else valueUnit



###
Determines an appropriate time unit.
@param seconds: The number of seconds to consider.
@returns string.
###
ns.elapsedUnit = (seconds) ->
  if seconds < 60
    'second'
  else if seconds < HOUR
    'minute'
  else if seconds < DAY
    'hour'
  else if seconds < YEAR
    'day'
  else
    'year'




###
Alias to 'formatElapsed' returning as parts.
###
ns.elapsed = (date, options = {}) ->
  options.asParts = true
  ns.formatElapsed(date, options)



###
Returns the display version of the 'formatElapsed' method.
@param date:    The [Date] to format, or the total seconds (number).
@param options: See 'formatElapsed' method.
###
ns.elapsedAgo = (date, options) -> ns.elapsed(date, options).display



###
Formats a date into a display string.
@param date: The date to format.
###
ns.displayDate = (date) ->
  result = ''
  return result unless date?
  if date.is('today')
    result = 'Today'
  else if date.is('yesterday')
    result = 'Yesterday'
  else
    result = date.format('{ord} {Mon} {yyyy}')
    if date.is('this week')
      result = date.format('{Weekday}, ') + result
  result += date.format(', {h}:{mm}{tt}')



###
Rounds a date to the closest half hour.
@param date: The date to effect (NOTE: this object is mutated).
@returns the changed date.
###
ns.roundToHalfHour = (date) ->
  hours   = date.getHours()
  minutes = date.getMinutes()

  if minutes < 30
    minutes = if minutes < 15 then 0 else 30
  else
    if minutes < 45
      minutes = 30
    else
      hours += 1
      minutes = 0

  date.set(hour:hours, minute:minutes)
  date

