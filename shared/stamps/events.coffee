###
Extends a stamp to support events with the methods:

  - on
  - off
  - trigger

###
if Meteor.isServer
  EventEmitter = Npm.require('events').EventEmitter

  EventEmitterStamp = stampit().enclose ->
    eventEmitter = new EventEmitter()

    @on = (eventName, func) -> eventEmitter.on(eventName, func)
    @trigger = (eventName, args) -> eventEmitter.emit(eventName, undefined, args)
    @off = (eventName) -> eventEmitter.removeAllListeners(eventName)

    return @

  Stamps.Events = stampit.compose(
    EventEmitterStamp
  )

if Meteor.isClient
  Stamps.Events = stampit().enclose ->
    Util.Events.extend(@)
    # ----------------------------------------------------------------------
    return @
