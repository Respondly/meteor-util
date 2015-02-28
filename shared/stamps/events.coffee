###
Extends a stamp to support events with the methods:

  - on
  - off
  - trigger

###
if Meteor.isServer
  EventEmitter = Npm.require('events').EventEmitter

  EventEmitterStamp = stampit().enclose ->
    @trigger = (eventName, args) -> @emit(eventName, undefined, args)
    @off = (eventName) -> @removeAllListeners(eventName)

    return @

  Stamps.Events = stampit.compose(
    stampit.convertConstructor(EventEmitter)
    EventEmitterStamp
  )

if Meteor.isClient
  Stamps.Events = stampit().enclose ->
    Util.Events.extend(@)
    # ----------------------------------------------------------------------
    return @
