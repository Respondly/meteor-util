ClientSettings = {}



###
CLIENT: Retreives application settings that have been distributed
        to the client.
        See corresponding [server] method: ClientSettings.set(...)
###
ClientSettings.get = ->
  __meteor_runtime_config__.CLIENT_SETTINGS
