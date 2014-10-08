Future = Npm.require 'fibers/future'

Server = {}
os = Npm.require('os')


###
Gets the server's host name.
###
Server.hostname = -> os.hostname()



###
Gets the server IP addresses.
@returns an array, usually with just one value.
###
Server.addresses = ->
  interfaces = os.networkInterfaces()
  addresses = []
  for k, v of interfaces
    for address in interfaces[k]
      if address.family == 'IPv4' && !address.internal
        addresses.push(address.address)
  addresses



###
Gets whether the app is running on a "development" machine.
To declare a machin as "dev" use the environment variable:

    export DEV_SERVER=true

###
Server.isDev = ->
  Util.isTrue(process.env.DEV_SERVER, default:false)




###
Pauses execution on the server for the specified timespan.
Useful when simulating latency.

@param msecs: The number of milliseconds to sleep for.

###
Server.sleep = (msecs) ->
  future = new Future()
  Util.delay msecs, -> future.return()
  future.wait()




###
Emits a common application startup boilerplate to the console.
@param appName: The name of the application.
###
Server.logStart = (appName = 'Untitled Application') ->
  HR = '-'.repeat(45).green

  port = process.env.ROOT_URL
  port = port.remove(/http:\/\/localhost/)
  port = port.remove(/\/$/)

  console.log HR
  console.log " #{ appName.trim() }".green, port.grey
  console.log HR

