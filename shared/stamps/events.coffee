###
Extends a stamp to support events with the methods:

  - on
  - off
  - trigger

###
Stamps.Events = stampit().enclose ->

  if Meteor.isServer
    throw new Meteor.Error(500, 'Not yet supported on server')

  if Meteor.isClient
    Util.Events.extends(@)


  # ----------------------------------------------------------------------
  return @
