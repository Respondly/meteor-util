describe.client 'AutoRun', ->
  class Sample extends AutoRun
  sample = null

  beforeEach -> sample = new Sample()
  afterEach -> sample.dispose()

  it 'has no handles by default', ->
    expect(sample.__internal__.depsHandles.length).to.equal 0


  it 'has two deps handles', ->
    sample.autorun =>
    sample.autorun =>
    expect(sample.__internal__.depsHandles.length).to.equal 2


  it 'invokes a reactive callback', (done) ->
    hash = new ReactiveHash()
    value = undefined
    sample.autorun => value = hash.get('foo')
    hash.set('foo', 123)
    expect(value).to.equal undefined
    Util.delay =>
      expect(value).to.equal 123
      done()

  it 'clears and stops handles when disposed', ->
    sample.autorun =>
    handle = sample.__internal__.depsHandles[0]
    expect(handle.stopped).to.equal false
    sample.dispose()
    expect(handle.stopped).to.equal true
    expect(sample.isDisposed).to.equal true
    expect(sample.__internal__.depsHandles).to.equal undefined


  it 'does not register new handles once disposed',  ->
    sample.dispose()
    sample.autorun =>
    sample.autorun =>
    sample.autorun =>
    expect(sample.__internal__.depsHandles).to.equal undefined
