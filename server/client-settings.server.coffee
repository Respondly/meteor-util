settings = __meteor_runtime_config__.CLIENT_SETTINGS = {}




###
Sets the settings that are distributed to the client.
@param props: An object containing the [key:value] pairs of settings.
###
ClientSettings.set = (props = {}) ->
  for key, value of props
    settings[key] = value
  settings

