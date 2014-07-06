describe 'ScopedSession: construct/dispose/singleton', ->
  session = null
  afterEach -> session?.dispose()

  it 'throws if there is not namespace', ->
    expect(-> new ScopedSession()).to.throw(/No namespace/)
    expect(-> new ScopedSession('')).to.throw(/No namespace/)
    expect(-> new ScopedSession('  ')).to.throw(/No namespace/)


  it 'has a namespace', ->
    session = new ScopedSession('ns')
    expect(session.namespace).to.equal 'ns'


  it 'stores global instance', ->
    session = new ScopedSession('ns')
    expect(ScopedSession.instances['ns']).to.equal session

  it 'removes global instance on dispose', ->
    session = new ScopedSession('ns')
    session.dispose()
    expect(ScopedSession.instances['ns']).to.be.undefined

  it 'clears state on dispose', ->
    session = new ScopedSession('ns')
    session.set('foo', 123)
    session.dispose()
    expect(session.isDisposed).to.equal true
    expect(session.keys()).to.eql []




describe 'ScopedSession: get/set', ->
  session = null
  beforeEach -> session = new ScopedSession('ns')
  afterEach -> session.dispose()

  it 'gets a value', ->
    Session.set 'ns:foo', 123
    expect(session.get('foo')).to.equal 123

  it 'sets a value', ->
    session.set 'foo', 'hello'
    expect(Session.get('ns:foo')).to.equal 'hello'

  it 'unsets a value', ->
    session.set 'foo', 123
    session.unset('foo')
    expect(Session.get('fs:foo')).to.equal undefined

  it 'cleans up Session object on unset', ->
    session.set 'foo', 123
    session.unset('foo')
    expect((key for key,value of Session.keys).any('ns:foo')).to.be.false
    expect((key for key,value of Session.keyDeps).any('ns:foo')).to.be.false
    expect((key for key,value of Session.keysValueDeps).any('ns:foo')).to.be.false

  it 'stores the set of keys', ->
    Session.set 'foo', 'yo' # Will not be namespaced.
    session.set 'foo', 123
    session.set 'bar', 456
    keys = session.keys()
    expect(keys.any('foo')).to.equal true
    expect(keys.any('bar')).to.equal true

  it 'clears all values', ->
    session.set 'foo', 123
    session.set 'bar', 456
    session.clear()
    expect(Session.get('fs:foo')).to.equal undefined
    expect(Session.get('fs:bar')).to.equal undefined
    expect(session.keys()).to.eql []



