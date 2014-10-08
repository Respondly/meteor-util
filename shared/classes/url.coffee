###
Represents a URL with helper functionality.
###
class Url
  ###
  Constructor.
  @param fullPath: The full path of the URL (including query-string).
  @param pattern:  (optional) A pattern that defines parameters within the URL, eg: /foo/:id
  ###
  constructor: (fullPath, pattern) -> @init(fullPath, pattern)


  init: (fullPath, pattern) ->
    # Setup initial conditions.
    @fullPath = fullPath
    @pattern = pattern

    # Format full path.
    @fullPath = '' if Util.isBlank(@fullPath)
    @fullPath = @fullPath.trim()

    # Extracts URL parts.
    parts = @fullPath.split('?')
    @path = parts[0]
    @queryString = parts[1] ? ''
    @query = new QueryString(@queryString)


    # Create an array of parts.
    parts  = @path.split('/').map (part) -> part.trim()
    @parts = parts.compact(true)

    # Flags.
    @isAbsolute = @path.startsWith('/')
    @isRelative = not @isAbsolute

    # Params.
    @params = {}
    if @pattern
      route = new PageJS.Route(@pattern)
      route.match(@path, @params)

    # Finish up.
    @



  ###
  Converts the URL to a string.
  ###
  toString: -> @fullPath


  ###
  Retrieves the parent of the
  @param options
          - query:
                - false:  No query string (default).
                - true:   Include the current query string.
                - string: specific query string to include.
  ###
  parent: (options = {}) ->
    # Setup initial conditions.
    return null if @parts.length < 2
    query = options.query ? false

    # Build the path.
    parts = @parts.clone().removeAt(@parts.length - 1)
    path = parts.join('/')
    path = '/' + path if @isAbsolute

    # Append a query string if required.
    if query?
      if query is true
        path = "#{ path }?#{ @queryString }"

      if Object.isString(query)
        query = query.remove /^\?/
        path = "#{ path }?#{ query }"

    # Finish up.
    new Url(path)



  ###
  CLIENT ONLY: Loads the given URL into the browser, adding it to the history.

  @param path: The URL to load.
  @param options:
            - force: Flag indicating if the URL should be loaded even if the existing
                     url is either the same, or an ancestor of the current URL.
                     (default:true)

                      Example when force==false:

                          Current URL path:  /root/foo/bar
                          New URL path:      /root/foo

                      The new URL would not be loaded.

  @returns true if the URL was loaded, of false if the non-forced load operation decided the URL should not be loaded.
  ###
  show: (options) -> Router?.show(@fullPath, options)



  ###
  Replaces the given URL into the browser, NOT adding it to the history.

  @param path: The URL to load.
  @param options:
            - force: Flag indicating if the URL should be loaded even if the existing
                     url is either the same, or an ancestor of the current URL.
                     (default:true)

                      Example when force==false:

                          Current URL path:  /root/foo/bar
                          New URL path:      /root/foo

                      The new URL would not be loaded.

  @returns true if the URL was loaded, of false if the non-forced load operation decided the URL should not be loaded.
  ###
  replace: (options) -> Router?.replace(@fullPath, options)



  # --------------------------------------------------------------------------


  ###
  Removes the given query-string keys.
  @param keys:  Optional. The keys within the query-string to remove.
                          Pass nothing to remove all keys.
  @returns the URL instance.
  ###
  removeQuery: (keys...) ->
    fullPath = @path
    if keys.length > 0
      delete @query[key] for key in keys
      fullPath += @query.toString()
    @init(fullPath, @pattern)



  ###
  Adds (or replaces) a query string value.
  @param key:   The query key.
  @param value: (optional) The value for the key
  @returns the URL instance.
  ###
  addQuery: (key, value) ->
    return @ unless key
    @query[key] = value ? ''
    @init(@path + @query.toString(), @pattern)


