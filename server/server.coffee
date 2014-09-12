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

