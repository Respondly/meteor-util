

###
Provides a way of pulsing an element.
###
class Util.Pulse
  constructor: (el, options = {}) ->
    @_el = el
    @duration = options.duration ? 1
    @opacity(options.opacity ? 1)
    el.css 'transition', "opacity #{ @duration }s"

  dispose: ->
    @isDisposed = true
    @stop()

  el: -> Util.asValue(@_el)

  opacity: (value) ->
    el = @el()
    el.css 'opacity', value if value isnt undefined
    el.css('opacity').toNumber()


  toggle: -> @opacity( if @opacity() is 1 then 0 else 1 )

  start: ->
    # Setup initial conditions.
    return if @isRunning or @isDisposed
    @isRunning = true

    # Toggle loop.
    toggle = =>
      if @isRunning and not @isDisposed
        @toggle()
        Util.delay (@duration * 1000), => toggle()

    # Finish up.
    toggle()
    @

  stop: ->
    @isRunning = false
    @


  # CLASS METHODS --------------------------------------------------------------------------



  ###
  CLASS METHOD - Starts an element pulsing.
  @param el: The element to pulse.
  @param options:
  @returns a new [Pulse] instance.
  ###
  @start: (el, options = {}) ->
    pulse = new Util.Pulse(el, options)
    Util.delay 100, -> pulse.start()
    pulse



