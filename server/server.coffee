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

