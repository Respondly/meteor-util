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




describe 'Util.isBlank', ->
  it 'is blank (nothing)', ->
    expect(Util.isBlank()).to.equal true
    expect(Util.isBlank(undefined)).to.equal true
    expect(Util.isBlank(null)).to.equal true

  it 'is blank (string)', ->
    expect(Util.isBlank('')).to.equal true
    expect(Util.isBlank('   ')).to.equal true

  it 'is blank (array)', ->
    expect(Util.isBlank([])).to.equal true
    expect(Util.isBlank([null])).to.equal true
    expect(Util.isBlank([undefined])).to.equal true
    expect(Util.isBlank([undefined, null])).to.equal true

  it 'is not blank (string)', ->
    expect(Util.isBlank('a')).to.equal false
    expect(Util.isBlank('   .')).to.equal false

  it 'is not blank (array)', ->
    expect(Util.isBlank([1])).to.equal false
    expect(Util.isBlank([null, 'value'])).to.equal false
    expect(Util.isBlank([null, ''])).to.equal false
    expect(Util.isBlank([null, '   '])).to.equal false

  it 'is not blank (other values)', ->
    expect(Util.isBlank(1)).to.equal false
    expect(Util.isBlank({})).to.equal false
    expect(Util.isBlank(-> )).to.equal false


describe 'Util.params', ->
  it 'has no params', ->
    expect(Util.params(-> )).to.eql []

  it 'has two params', ->
    fn = (one, two) ->
    expect(Util.params(fn)).to.eql ['one', 'two']

  it 'returns an empty array for (args...)', ->
    fn = (args...) ->
    expect(Util.params(fn)).to.eql []

  it 'returns an empty array when a non-function is passed', ->
    expect(Util.params('foo')).to.eql []
    expect(Util.params({})).to.eql []



describe 'Util.hash', ->
  it 'returns 0 when string is empty', ->
    expect(Util.hash('')).to.equal 0

  it 'throws when a non-string is passed', ->
    fn = -> Util.hash({})
    expect(fn).to.throw(/Can only hash strings/)

  it 'hashes a string multiple times with the same result', ->
    result1 = Util.hash('foo')
    result2 = Util.hash('foo')
    expect(result1).to.equal result2





