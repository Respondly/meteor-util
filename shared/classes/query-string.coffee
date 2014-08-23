###
Converts a query-string into a hash.
###
class QueryString
  constructor: (queryString) ->
    if Object.isString(queryString) and not queryString.isBlank()
      for item in queryString.split('&')
        parts = item.split('=')
        @[parts[0]] = parts[1]

    if Util.isObject(queryString)
      Object.merge(@, queryString)



  ###
  Makes a copy of the query-string hash.
  @param options:  (optional) Object contaning new values to write.
  ###
  clone: (options) ->
    clone = new QueryString(@)
    if options
      Object.merge(clone, options)
    clone



  ###
  Convers the query to a string.
  ###
  toString: ->
    result = ''
    for key, value of @
      unless value is undefined or Object.isFunction(value)
        key = "#{ key }=#{ value }" if value
        result += key + '&'
    result = result.remove /\&$/
    result = '?' + result if result.length > 0
    result

