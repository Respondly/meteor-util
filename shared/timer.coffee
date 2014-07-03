###
Provides a more convenient way of settings a timeout.
@param milliseconds:  The milliseconds to delay.
@param func:          The function to invoke.
@returns The timer handle.  Use the [stop] method to cancel the timer.
###
Util.delay = (milliseconds, func) ->
  # Check parameters.
  if Object.isFunction(milliseconds)
    func = milliseconds
    milliseconds = 0 # Immediate "defer" when no milliseconds value specified.

  return unless Object.isFunction(func)

  # Return an object with the running timer.
  result =
    id: Meteor.setTimeout(func, milliseconds)
    stop: -> Meteor.clearTimeout(@id)


