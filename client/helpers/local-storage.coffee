hash = new ReactiveHash(onlyOnChange:true)

LocalStorage =
  ###
  Gets or sets the value for the given key.
  @param key:         The unique identifier of the value (this is prefixed with the namespace).
  @param value:       (optional). The value to set (pass null to remove).
  @param options:
            default:  (optional). The default value to return if the session does not contain the value (ie. undefined).
  ###
  prop: (key, value, options = {}) ->
    # Ensure the read operations are reactive.
    hash.prop(key, value, options)

    if value isnt undefined
      # WRITE.
      type =  if Object.isString(value)
                'string'
              else if Object.isBoolean(value)
                'bool'
              else if value is null
                'null'
              else if Object.isNumber(value)
                'number'
              else
                'object'

      writeValue = { value:value, type:type }
      localStorage.setItem(key, JSON.stringify(writeValue))

    else
      # READ ONLY.
      if json = localStorage.getItem(key)
        json = JSON.parse(json)
        value = switch json.type
                  when 'null', 'bool', 'string' then json.value
                  when 'number' then json.value.toNumber()
                  when 'object' then json.value

      else
        value = undefined
      value = options.default if value is undefined

    # Finish up.
    value

