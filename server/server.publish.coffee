#= require ./server



###
Logs a publish event to the console.
@param name:      The name of the published data-set.
@param startedAt: The Date/Time the publish operation started exeucuting.
@param options:
          - cursors: The collection of cursors.
###
Server.logPublish = (name, startedAt, options = {}) ->
  text = 'publish: '.grey + "#{ name }".cyan
  if options.cursors
    total   = options.cursors.length
    text += " #{ total } #{ Util.string.plural(total, 'cursor') }".grey
  text += " in #{ startedAt.millisecondsAgo().round(2) } msecs".grey
  console.log(text)






###
Runs the given publish function logging in a standard manner.

@param name:                    The name of the published data-set.

@param ...                      Other arguments.

@param func(args):  The publish function that retrieves the cursors.
                    The [this] context contains the:
                      - user (model)
###
Server.publish = (name, func) ->
  throw new Error("Publish name not specified ") unless Object.isString(name)
  throw new Error("Publish function not specified") unless Object.isFunction(func)

  Meteor.publish name, (args...) ->
      startedAt = new Date()
      cursors   = []

      @user   = APP.models.User.findOne(@userId) if @userId
      cursors = func.apply @, args
      cursors = [cursors] unless Object.isArray(cursors)
      cursors = cursors.flatten().compact()

      # Finish up.
      Server.logPublish(name, startedAt, cursors:cursors)
      cursors

