###
Represents a user-agent string.
###
class UserAgent
  constructor: (@raw) ->
    @raw ?= window?.navigator?.userAgent ? ''


  ###
  Determines whether the given text is contained within the user agent.
  @param substring: The text to look for.
  ###
  contains: (substring) ->
    return false unless Object.isString(substring)
    regex = new RegExp(substring, 'g')
    (@raw.match(regex)?.length ? 0) isnt 0


  isIE: -> @contains('MSIE')
  isFirefox: -> @contains('Firefox')
  isChrome: -> @contains('Chrome')
  isSafari: -> @contains('Safari') and not @isChrome() # NB: Chrome contains a reference to Safari.
  isWebKit: -> @contains('AppleWebKit')

  isMobile: -> @contains('Mobile')
  isDesktop: -> not @isMobile()

  # A browser embedded within a native mobile app.
  isWebView: -> /(iPhone|iPod|iPad).*AppleWebKit(?!.*Safari)/i.test(@raw)

  isMac: -> @contains('Macintosh')
  isWindows: -> @contains('Windows')

  isPhantomJS: -> @contains('PhantomJS')

  browser: ->
    return 'Chrome' if @isChrome()
    return 'Safari' if @isSafari()
    return 'Firefox' if @isFirefox()
    return 'IE' if @isIE()
    'Unknown Browser'


  ###
  Simple object containing each value.
  ###
  toObject: ->
    result = {}
    for own key, value of @
      result[key] = @[key]() if key.startsWith('is')
    result

  ###
  Display string summary of the user-agent.
  ###
  toString: ->
    result = @browser()
    result += ', OS: '
    result += 'Mac' if @isMac()
    result += 'Windows' if @isWindows()
    result += 'Other' if not @isMac() and not @isWindows()

    if @isMobile() or @isDesktop()
      result += ', Platform: '
      result += 'mobile' if @isMobile()
      result += 'desktop' if @isDesktop()

    result

