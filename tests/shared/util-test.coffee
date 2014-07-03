describe 'Util.isObject (true)', ->
  it 'is a literal object', ->
    expect(Util.isObject({})).to.equal true
    expect(Util.isObject({ foo:123 })).to.equal true

  it 'is a derived object', ->
    class Foo
    foo = new Foo()
    expect(Util.isObject(foo)).to.equal true

describe 'Util.isObject (false)', ->
  it 'when string', ->
    expect(Util.isObject('foo')).to.equal false

  it 'when number', ->
    expect(Util.isObject(123)).to.equal false

  it 'when function', ->
    expect(Util.isObject(-> )).to.equal false

  it 'array', ->
    expect(Util.isObject([])).to.equal false
    expect(Util.isObject([1,2,3])).to.equal false

  it 'when null | undefined', ->
    expect(Util.isObject()).to.equal false
    expect(Util.isObject(undefined)).to.equal false
    expect(Util.isObject(null)).to.equal false
