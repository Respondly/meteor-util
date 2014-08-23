UPDATE_KEY = 'update'


setDuration = (el, duration) ->
    value = if duration is 0 then '' else "max-height #{ duration }s"
    el.css 'transition', value
    duration


# ----------------------------------------------------------------------


###
Provides a way of animating the height of an element.
###
class Util.HeightAnimator
  ###
  Constructor.
  @param elOuter: The outer that will have it's height changed.
                  el, function
  @param options:
            - elInner:            Optional. The inner content which is being hidden.
                                            If not specified the first child of [elOuter] is used.
            - duration:           Optional. The default duration in seconds.  Default: 0.2 secs
            - visible:            Optional. Flag indicating if the element is visible upon creation.  Default:true.
            - withClasses         Optional. Flag indicating if showing/hidden state classes are added to the outer element.  Default:true.
  ###
  constructor: (elOuter, @options = {}) ->
    # Setup initial conditions.
    @_elOuter = elOuter
    @duration = @options.duration ? 0.2
    @hash     = new ReactiveHash()


  init: ->
    visible = Deps.nonreactive => Util.asValue(@options.visible) ? true
    if visible then @show(duration:0) else @hide(duration:0)
    @


  dispose: ->
    @isDisposed = true
    delete @_elOuter
    delete @options
    @hash.dispose()


  updateState: ->
    elements = [ @elOuter(), @elInner() ].compact()
    for el in elements
      el.toggleClass 'is-animating', @isAnimating()
      el.toggleClass 'is-showing', @isShowing()
      el.toggleClass 'is-hidden', @isHidden()



  elOuter: -> Util.asValue(@_elOuter)
  elInner: ->
    elOuter = @elOuter()
    el = Util.asValue(@options.elInner) # Look for explicitly set value.
    el = elOuter.find(el) if Object.isString(el)  # Selector within the outer-element.
    el = $(elOuter.children()[0]) unless el       # First child of the outer-element.
    el



  ###
  Gets whether the element is currenlty visible.
  ###
  isShowing: -> @height() > 0

  ###
  Gets whether the element is currenlty hidden.
  ###
  isHidden: -> not @isShowing()


  ###
  REACTIVE: Gets whether the element is currently being animated.
  ###
  isAnimating: (value) -> @hash.prop 'is-animating', value, default:false


  ###
  REACTIVE: Gets the current height of the element.
  ###
  height: ->
    @hash.get(UPDATE_KEY) # Hook into reactive context.
    @elOuter()?.outerHeight() ? 0




  ###
  Toggles show/hide.
  @param toggle: Optional.  Flag indicating whether to show or hide.
  @param options:
            duration: Optional. The duration in seconds.
            force:    Optional. Flag indiacting if the show/hide method should be forced
                                if already in the resulting state.
                                Default: false
            callback: Optional. Invoked upon completion.
  @returns boolean.  True if toggled to showing, otherwise False.
  ###
  toggle: (toggle, options = {}) ->
    # Setup initial conditions.
    options = toggle if Util.isObject(toggle)
    toggle  = not @isShowing() if not Object.isBoolean(toggle)
    force   = options.force ? false

    # Show or hide the element.
    if toggle
      @show(options) if force or not @isShowing()
    else
      @hide(options) if force or @isShowing()

    # Finish up.
    toggle


  ###
  Reveals the element.
  @param options:
            duration: Optional. The duration in seconds.
            callback: Optional. Invoked upon completion.
  ###
  show: (options = {}) ->
    if el = @elOuter()
      # Setup initial conditions.
      duration = setDuration(el, options.duration ? @duration)
      el.toggle(true)

      # Start the animation.
      @isAnimating(true) if duration > 0
      el.css 'max-height', @elInner().outerHeight() + 'px'
      @updateState()

      Util.delay (duration * 1000), =>
          # Finish up.
          @isAnimating(false) if @isAnimating() is true
          el.css 'overflow', ''
          options.callback?()
          @updateState()
          @invalidate()



  ###
  Hides the element.
  @param options:
            duration: Optional. The duration in seconds.
            callback: Optional. Invoked upon completion.
  ###
  hide: (options = {}) ->
    if el = @elOuter()
      # Setup initial conditions.
      duration = setDuration(el, options.duration ? @duration)
      el.css 'overflow', 'hidden'

     # Start the animation.
      @isAnimating(true) if duration > 0
      el.css 'max-height', '0px'
      @updateState()

      Util.delay (duration * 1000), =>
          # Finish up.
          el.toggle(false)
          @isAnimating(false) if @isAnimating() is true
          options.callback?()
          @updateState()
          @invalidate()



  invalidate: -> @hash.set UPDATE_KEY, +(new Date())

