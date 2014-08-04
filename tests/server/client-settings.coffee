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



