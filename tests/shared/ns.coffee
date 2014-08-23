describe 'Util.ns: getOrCreate', ->
  it 'creates a new object', ->
    root = {}
    foo = Util.ns.get(root, 'path.foo')
    expect(foo).to.be.an 'object'
    expect(root.path.foo).to.exist

  it 'creates a new object from namespace as array', ->
    root = {}
    foo = Util.ns.get(root, ['path', 'foo'])
    expect(foo).to.be.an 'object'
    expect(root.path.foo).to.exist

  it 'retrieves the same object', ->
    root = {}
    foo1 = Util.ns.get(root, 'path.foo')
    foo2 = Util.ns.get(root, 'path.foo')
    expect(foo1).to.equal foo2

  it 'returns different objects from different roots', ->
    root1 = {}
    root2 = {}
    foo1 = Util.ns.get(root1, 'path.foo')
    foo2 = Util.ns.get(root2, 'path.foo')
    expect(foo1).not.to.equal foo2

  it 'returns a single level path', ->
    root = {}
    foo = Util.ns.get(root, 'foo')
    expect(root.foo).to.exist

  it 'returns nothing', ->
    root = {}
    expect(Util.ns.get()).not.to.exist
    expect(Util.ns.get(root)).not.to.exist
    expect(Util.ns.get(root, null)).not.to.exist
    expect(Util.ns.get(root, '')).not.to.exist
    expect(Util.ns.get(root, '  ')).not.to.exist



describe 'Util.ns', ->
  ###
  NOTE: Root would typically be something like APP or AppName.
  ###
  ROOT = null
  beforeEach -> ROOT = {}

  it 'creates a single cached namespace', ->
    ns1 = Util.ns ROOT, 'test'
    ns2 = Util.ns ROOT, 'test'
    ns1.foo = 123
    expect(ns2.foo).to.equal 123


