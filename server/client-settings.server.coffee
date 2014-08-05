###
This value is passed by Meteor to the client.
###
settings = __meteor_runtime_config__.CLIENT_SETTINGS = {}




###
Sets the settings that are distributed to the client.

Examples:

    ClientSettings.set({ foo:123 })
    ClientSettings.set('myKey', { foo:123 })
    ClientSettings.set('myNumber', 123)


@param key:   (optional) The root keyname for the props.
@param props: An object containing the [key:value] pairs of settings.
###
ClientSettings.set = (key, props) ->
  # Setup initial conditions.
  if Object.isObject(key)
    props = key
    key = null

  if key
    target = settings[key] ? props
    settings[key] = target
  else
    target = settings

  # Store values.
  if Object.isObject(props)
    target[k] = value for k, value of props

  # Finish up.
  settings

