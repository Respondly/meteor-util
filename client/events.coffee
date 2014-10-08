###
Provides an eventing mechanism for objects.
###
Events = class Util.Events
  on:      => @event().on.apply( @$, arguments )
  off:     => @event().off.apply( @$, arguments )
  trigger: => @event().trigger.apply( @$, arguments )

  event: ->
    @$ = $({}) unless @$?
    @$

  extend: (obj) ->
    obj.on      = @on
    obj.off     = @off
    obj.trigger = @trigger



# CLASS METHODS --------------------------------------------------------------------------



###
Extends an object to support events.
###
Events.extend = (obj) ->
  events = new Events()
  events.extend(obj)
  events



# UTILITY EVENT METHODS --------------------------------------------------------------------------



###
Determines whether the given click event args was
from the Left mouse button.
@param e: The arguments from the click event.
###
Util.isLeftClick = (e) -> e.which is 1

###
Determines whether the given click event args was
from the Right mouse button.
@param e: The arguments from the click event.
###
Util.isRightClick = (e) -> e.which is 3

