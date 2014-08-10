OBSERVE_ACTIONS = ['added', 'changed', 'removed']


###
An observable, reactive array.
###
class ReactiveArray
  constructor:  ->
    @items = []
    @hash = new ReactiveHash()


  dispose: ->
    @hash.dispose()
    @isDisposed = true
    if @_handlers
      for action in OBSERVE_ACTIONS
        @_handlers[action]?.dispose()


  ###
  REACTIVE: The number of items in the array (1-based).
  ###
  count: (value) -> @hash.prop 'count', value, default:0


  ###
  Finds an index.
  @param func:      A function, will use native implementation if it exists.
                    func will also match a string, number, array, object, or alternately
                    test against a function or regex.
  ###
  indexOf: (func) ->
    if Util.isObject(func)
      # NOTE: Calling the native "indexOf" for an object prevents functions
      #       on the object being executed by Sugar.
      @items.indexOf(func)
    else
      @items.findIndex(func)



  ###
  Gets or sets the item at the given index.
  @param index: The index of the item to retrieve.
  @param value: (optional) The value if writing.
  ###
  item: (index, value) ->
    # Write.
    if value isnt undefined
      if index > @items.length - 1
        @add(value)
      else
        oldValue = @items[index]
        @items[index] = value
        @_handlers?.changed?.invoke(oldValue, value, index)

    # Read.
    @items[index]


  ###
  Alias to the "item" method.
  NOTE: Included because this syntax ("at") can make the intent
        of consuming code easier to read.
  ###
  itemAt: (index, value) -> @item(index, value)


  ###
  Maps the array to another array containing the values that are the result
  of calling the specified function.
  @param func(value): The map function.
  ###
  map: (func) -> @items.map(func)


  ###
  Enumerates over each item in the array.
  @param func(value): The function to invoke for each item.
  ###
  each: (func) -> @items.each(func)


  ###
  Registers a set of callbacks to be invoked when the array changes.
  @param callbacks (object):
            added: (value, index) ->
            removed: (value, index) ->
            changed: (oldValue, newValue, index) ->
  ###
  observe: (callbacks = {}) ->
    handlersSet = @_handlers ?= {}
    for action in OBSERVE_ACTIONS
      if callback = callbacks[action]
        handlers = handlersSet[action] ?= new Handlers(@)
        handlers.push(callback)


  ###
  Adds a new item to the array.
  @param value: The value to add.
  @param atIndex: The 0-based index to add at.
  ###
  add: (value, atIndex) ->
    Deps.nonreactive =>
      atIndex = @items.length unless atIndex?
      @items.add(value, atIndex)
      @count(@items.length)
      @_handlers?.added?.invoke(value, atIndex)
      @

  ###
  Altnerative name to "add".
  ###
  push: (value) -> @add(value)


  ###
  Removes the item at the given index.
  @param start: The 0-based index to remove.
  @param end:   If end is specified, removes the range between start and end.
  ###
  removeAt: (start, end) ->
    Deps.nonreactive =>
      # Setup initial conditions.
      return @ if not start?
      return @ if start < 0
      return @ if start > @items.length - 1
      removedHandlers = @_handlers?.removed

      if removedHandlers
        end ?= start
        values = []
        for index in [start..end]
          values.push { index:index, value:@item(index) }

      # Perform the removal.
      @items.removeAt(start, end)
      @count(@items.length)

      # Invoke "removed" callbacks.
      if removedHandlers = @_handlers?.removed
        for item in values
          removedHandlers.invoke(item.value, item.index)

      # Finish up.
      @



  ###
  Removes any element in the array that matches the given value(s).
  @param value:   A string, number, array, object, or alternately
                  test against a function.
  ###
  remove: (values...) ->
    for value in values
      if Object.isFunction(value)
        func = value
        for item in @items.clone()
          @removeAt(@indexOf(item)) if func(item)
      else
        @removeAt(@indexOf(value))

    # Finish up.
    @


