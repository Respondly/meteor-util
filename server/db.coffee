db = Util.db ?= {}


all =
  insert: -> true
  update: -> true
  remove: -> true


###
Denies all DB operations on the given collection.
Note:
    This is the default when the [autopublish] package is removed
    however it is nice to be explicit.

@param collection: The Meteor collection to change.
###
db.denyAll = (collection) ->
  collection.deny(all) if (collection instanceof Meteor.Collection)



###
Allows all DB operations on the given collection.
Note:
    This is the default when the [autopublish] package is removed
    however it is nice to be explicit.

@param collection: The Meteor collection to change.
###
db.allowAll = (collection) ->
  collection.allow(all) if (collection instanceof Meteor.Collection)



###
Retrieves a random id that does not already exist within the given colleciton.
@param length:      The number of characters within the ID.
@param collection:  The collection to be unique within.
@param options:
          - lowercase: Boolean.  Flag indicating if the ID should be forced to lowercase.
                                 Default:false
@returns string.
###
db.uniqueId = (length, collection, options = {}) ->
  throw new Error("Collection not specified") unless collection
  lowercase = options.lowercase ? false

  generate = ->
          # Retrieve an ID at the given length.
          id = Random.id()
          if length > id.length
            throw new Error("ID length must be less than #{ id.length + 1 } chars.")
          id = id.first(length)
          id = id.toLowerCase() if lowercase

          # Ensure it does not already exist within the collection.
          if collection.findOne(_id:id)?
            # Already exists, generate a new ID.
            return generate() # <== RECURSION.

          else
            return id

  generate()





