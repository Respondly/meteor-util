Meteor.startup ->
  elBody = $('body')

  # Store classes for the current browser.
  UserAgent.current = userAgent = new UserAgent()

  elBody.toggleClass 'webkit', userAgent.isWebKit()
  elBody.toggleClass 'firefox', userAgent.isFirefox()
  elBody.toggleClass 'ie', userAgent.isIE()
  elBody.toggleClass 'chrome', userAgent.isChrome()
  elBody.toggleClass 'safari', userAgent.isSafari()
  elBody.toggleClass 'mobile', userAgent.isMobile()
  elBody.toggleClass 'desktop', userAgent.isDesktop()
  elBody.toggleClass 'windows', userAgent.isWindows()
  elBody.toggleClass 'mac', userAgent.isMac()

  # Add a class telling the HTML that it is being run within Phantom-JS.
  #   NOTE: This will typically be the case when running within a process so
  #         that is can be crawled by search-engine spiders.
  #
  #         To test what the page looks like when rendered for the spider use:
  #
  #           http://<domain>/?_escaped_fragment_=
  #
  elBody.toggleClass 'phantom-js', userAgent.isPhantomJS()


