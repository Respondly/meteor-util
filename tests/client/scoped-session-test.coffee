describe 'ScopedSession: construct/dispose', ->
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



describe 'ScopedSession: [prop] Property helper', ->
  session = null
  beforeEach -> session = new ScopedSession('ns')
  afterEach -> session.dispose()

  it 'read: gets a value', ->
    session.set 'foo', 123
    expect(session.prop('foo')).to.equal 123

  it 'read: gets no value (undefined)', ->
    expect(session.prop('foo')).to.equal undefined

  it 'read: gets a default value', ->
    expect(session.prop('foo', undefined, default:'hello')).to.equal 'hello'

  it 'read: does not get the default value when the value is null', ->
    session.prop 'foo', null
    expect(session.prop('foo', undefined, default:'hello')).to.equal null

  it 'writes a value', ->
    value = session.prop 'foo', 123
    expect(value).to.equal 123
    expect(session.get('foo')).to.equal 123

  it 'writes null', ->
    value = session.prop 'foo', null
    expect(value).to.equal null
    expect(session.get('foo')).to.equal null

  it 'does not write when [undefined] is passed (read operation)', ->
    session.set 'foo', 123
    session.prop 'foo', undefined
    expect(session.get('foo')).to.equal 123



describe 'ScopedSession: Singleton', ->
  afterEach -> ScopedSession.reset()

  it 'retrieves a singleton', ->
    session1 = ScopedSession.singleton('ns')
    session2 = ScopedSession.singleton('ns')
    expect(session1).to.equal session2


  it 'dispsoes of all singletons (reset)', ->
    session1 = new ScopedSession('ns1')
    session2 = new ScopedSession('ns2')

    expect(ScopedSession.instances['ns1']).to.exist
    expect(ScopedSession.instances['ns2']).to.exist

    ScopedSession.reset()

    expect(ScopedSession.instances['ns1']).not.to.exist
    expect(ScopedSession.instances['ns2']).not.to.exist







