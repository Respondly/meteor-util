###
Provides a more convenient way of setting a timeout.

@param msecs:  The milliseconds to delay.
@param func:   The function to invoke.

@returns  The timer handle.
          Use the [stop] method to cancel the timer.
###
Util.delay = (msecs, func) ->
  # Check parameters.
  if Object.isFunction(msecs)
    func = msecs
    msecs = 0 # Immediate "defer" when no milliseconds value specified.

  return unless Object.isFunction(func)

  # Return an object with the running timer.
  result =
    msecs: msecs
    id:    Meteor.setTimeout(func, msecs)
    stop: -> Meteor.clearTimeout(@id)


###
Provides a more convenient way of setting an interval.

@param msecs:  The period of the function call in milliseconds.
@param func:   The function to invoke.

@returns  The interval handle.
          Use the [stop] method to cancel the interval.
###
Util.interval = (msecs, func) ->
  # both arguments required
  return unless Object.isNumber(msecs)
  return unless Object.isFunction(func)

  # Return an object with the running timer.
  result =
    msecs: msecs
    id:    Meteor.setInterval(func, msecs)
    stop: -> Meteor.clearInterval(@id)