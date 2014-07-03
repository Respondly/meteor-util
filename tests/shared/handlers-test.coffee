Handlers = Util.Handlers


describe 'Handlers (Init)', ->
  handlers = null
  beforeEach -> handlers = new Handlers()

  it 'constructs with no context or handlers', ->
    expect(handlers.count()).to.equal 0
    expect(handlers.context).to.equal undefined

  it 'flattens handlers within constructor', ->
    func1 = ->
    func2 = ->
    func3 = ->
    handlers = new Handlers(@, func1, [func2, func3])
    expect(handlers.count()).to.equal 3

  it 'is disposable', ->
    handlers.push ->
    expect(handlers.items.length).to.equal 1
    handlers.dispose()
    expect(handlers.items.length).to.equal 0
    expect(handlers.isDisposed).to.equal true



describe 'Handlers.add', ->
  handlers = null
  beforeEach -> handlers = new Handlers()

  it 'adds a handler to the array', ->
    fn = ->
    handlers.add(fn)
    expect(handlers.items.any((item) -> item.func is fn)).to.equal true

  it 'does not add a non-function to the array', ->
    handlers.add(123)
    expect(handlers.items.any((item) -> item.func is fn)).to.equal false

  it 'returns a handle', ->
    fn1 = ->
    fn2 = ->
    result1 = handlers.add(fn1)
    result2 = handlers.add(fn2)

    expect(result1.func).to.equal fn1
    expect(result2.func).to.equal fn2

  it 'uses "push" as an alias to "add"', ->
    fn = ->
    handlers.push(fn)
    expect(handlers.items.any((item) -> item.func is fn)).to.equal true



describe 'Handlers.remove', ->
  handlers = null
  beforeEach -> handlers = new Handlers()

  it 'removes a handler from the array', ->
    fn = ->
    handlers.add(fn)
    wasRemoved = handlers.remove(fn)
    expect(handlers.items.any((item) -> item.func is fn)).to.equal false
    expect(wasRemoved).to.equal true
    expect(handlers.items).to.eql []

  it 'does not remove a handler that did not exist', ->
    handlers.add(-> )
    wasRemoved = handlers.remove(-> )
    expect(wasRemoved).to.equal false

  it 'removes the handle via the [stop] method', ->
    fn = ->
    handle = handlers.add(fn)
    expect(handlers.contains(fn)).to.equal true
    handle.stop()
    expect(handlers.contains(fn)).to.equal false

  it 'removes all handles on [dispose]', ->
    handlers.add ->
    handlers.add ->
    handlers.add ->

    expect(handlers.items.length).to.equal 3
    handlers.dispose()

    expect(handlers.items.length).to.equal 0




describe 'Handlers.invoke', ->
  handlers = null
  beforeEach -> handlers = new Handlers()

  it 'invokes handlers returning true', ->
    count = 0
    fn1 = -> count += 1
    fn2 = -> count += 1
    handlers.add(fn1)
    handlers.add(fn2)
    result = handlers.invoke()
    expect(result).to.equal true
    expect(count).to.equal 2

  it 'invokes handlers returning false (cancelled)', ->
    fn1 = -> true
    fn2 = -> false
    handlers.add(fn1)
    handlers.add(fn2)
    result = handlers.invoke()
    expect(result).to.equal false

  it 'invokes handlers within a context', ->
    obj = {}
    context = null

    handlers = new Handlers(obj)
    handlers.add -> context = @
    handlers.invoke()
    expect(context).to.equal obj

  it 'invokes handlers with arguments', ->
    param1 = null
    param2 = null
    handlers.add (p1, p2) ->
      param1 = p1
      param2 = p2
    handlers.invoke(123, 'abc')
    expect(param1).to.equal 123
    expect(param2).to.equal 'abc'

  it 'returns true when invoking with no handlers', ->
    handlers = new Handlers()
    result = handlers.invoke()
    expect(result).to.equal true


describe 'Handlers.invokeAsync', ->
  handlers = null
  beforeEach -> handlers = new Handlers()

  it 'invokes returns true when there are no handlers', (done) ->
    handlers.invokeAsync (result, err) =>
      @try ->
        expect(result).to.equal true
        expect(err).to.equal undefined
      done()

  it 'invokes handlers returning true', (done) ->
    count = 0
    handlers.add (done) ->
      count += 1
      done()
    handlers.add (done) ->
      count += 1
      Util.delay -> done()

    handlers.invokeAsync (result, err) =>
      @try ->
        expect(count).to.equal 2
        expect(result).to.equal true
      done()


  it 'invokes handlers returning false (cancelled)', (done) ->
    finalHandlerSkipped = true
    handlers.add (done) -> done()
    handlers.add (done) -> done(false)
    handlers.add (done) -> finalHandlerSkipped = false

    handlers.invokeAsync (result) =>
      @try ->
        expect(result).to.equal false
        expect(finalHandlerSkipped).to.equal true
      done()


  it 'invokes handlers with arguments', (done) ->
    handlers = new Handlers()
    obj = {}
    context = null

    param1 = null
    param2 = null
    handlers.add (p1, p2) ->
      param1 = p1
      param2 = p2
      done()

    handlers.invokeAsync 123, 'abc', (result) =>
      @try ->
        expect(param1).to.equal 123
        expect(param2).to.equal 'abc'
      done()

  it 'returns true when invoking with no handlers', (done) ->
    handlers = new Handlers()
    handlers.invokeAsync (result) =>
      @try ->
        expect(result).to.equal true
      done()



describe 'Handlers.results', ->
  handlers = null
  beforeEach -> handlers = new Handlers()

  it 'returns an empty array', ->
    expect(handlers.results()).to.eql []

  it 'returns an array of values', ->
    count = 0
    fn = ->
    fn1 = -> null
    fn2 = -> undefined
    fn3 = -> ''
    fn4 = -> false
    fn5 = -> fn

    handlers.push(fn1)
    handlers.push(fn2)
    handlers.push(fn3)
    handlers.push(fn4)
    handlers.push(fn5)
    results = handlers.results()
    expect(results.length).to.equal 5
    expect(results[0]).to.equal null
    expect(results[1]).to.equal undefined
    expect(results[2]).to.equal ''
    expect(results[3]).to.equal false
    expect(results[4]).to.equal fn


describe 'Handlers.firstResult', ->
  handlers = null
  beforeEach -> handlers = new Handlers()

  it 'returns no value', ->
    count = 0
    fn1 = ->
      count += 1
      null
    fn2 = ->
      count += 1
      undefined

    handlers.push(fn1)
    handlers.push(fn2)
    result = handlers.firstResult()
    expect(result).to.equal undefined
    expect(count).to.equal 2

  it 'returns the first handler value', ->
    fn1 = -> 'one'
    fn2 = ->
    handlers.push(fn1)
    handlers.push(fn2)
    expect(handlers.firstResult()).to.equal 'one'

  it 'returns the second handler value', ->
    fn1 = ->
    fn2 = ->
    fn3 = -> 'three'
    handlers.push(fn1)
    handlers.push(fn2)
    handlers.push(fn3)
    expect(handlers.firstResult()).to.equal 'three'


