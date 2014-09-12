Future = Npm.require 'fibers/future'




###
Pauses execution on the server for the specified timespan.
Useful when simulating latency.

@param msecs: The number of milli-seconds to sleep for.

###
Util.sleep = (msecs) ->
  future = new Future()
  Util.delay msecs, -> future.return()
  future.wait()




###
Emits a common application startup boilerplate to the console.
@param appName: The name of the application.
###
Util.logStart = (appName = 'Untitled Application') ->
  HR = '-'.repeat(45).green

  port = process.env.ROOT_URL
  port = port.remove(/http:\/\/localhost/)
  port = port.remove(/\/$/)

  console.log HR
  console.log " #{ appName.trim() }".green, port.grey
  console.log HR
