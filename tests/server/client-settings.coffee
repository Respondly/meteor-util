describe.server 'ClientSettings.set (server)', ->
  it 'sets client settings (return value)', ->
    result = ClientSettings.set({foo:123})
    expect(result.foo).to.equal 123


  it 'reads client settings (read method)', ->
    ClientSettings.set({foo:123})
    expect(ClientSettings.get().foo).to.equal 123


  it 'overwrites a client setting', ->
    ClientSettings.set({foo:123})
    ClientSettings.set({foo:'abc'})
    expect(ClientSettings.get().foo).to.equal 'abc'


  it 'sets properties with a key parameter (object)', ->
    ClientSettings.set('myKey', {bar:'abc'})
    expect(ClientSettings.get().myKey.bar).to.equal 'abc'


  it 'adds to existing property object via key', ->
    ClientSettings.set('myKey', {bar:'abc'})
    ClientSettings.set('myKey', {bar:'new', baz:456})
    ClientSettings.set('myKey', {foo:{ child:123 }})
    expect(ClientSettings.get().myKey.bar).to.equal 'new'
    expect(ClientSettings.get().myKey.baz).to.equal 456
    expect(ClientSettings.get().myKey.foo.child).to.equal 123


  it 'sets a simple value with a key parameter', ->
    ClientSettings.set('key1', 'abc')
    ClientSettings.set('key2', 123)
    expect(ClientSettings.get().key1).to.equal 'abc'
    expect(ClientSettings.get().key2).to.equal 123



