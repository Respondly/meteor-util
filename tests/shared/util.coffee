describe 'Util.asValue', ->
  it 'return undefined/null', ->
    expect(Util.asValue()).to.equal undefined
    expect(Util.asValue(null)).to.equal null

  it 'returns a simple value', ->
    expect(Util.asValue('foo')).to.equal 'foo'
    expect(Util.asValue(' ')).to.equal ' '
    expect(Util.asValue(123)).to.equal 123
    expect(Util.asValue({foo:123})).to.eql {foo:123}
    expect(Util.asValue([1,2,3])).to.eql [1,2,3]

  it 'returns the result of a function', ->
    expect(Util.asValue(-> 123)).to.equal 123

  it 'returns a curried function', ->
    fn = -> 123
    expect(Util.asValue(-> fn)).to.equal fn
    expect(Util.asValue(-> fn)()).to.equal 123



# ----------------------------------------------------------------------


describe 'Util.firstValue', ->
  it 'returns undefined', ->
    expect(Util.firstValue()).to.equal undefined

  it 'returns null', ->
    expect(Util.firstValue(null)).to.equal null

  it 'returns default when no value', ->
    expect(Util.firstValue(undefined, 123)).to.equal 123
    expect(Util.firstValue((-> ), 123)).to.equal 123

  it 'returns the first value', ->
    expect(Util.firstValue([1,2,3])).to.equal 1

  it 'returns the first value from function', ->
    expect(Util.firstValue([(-> 'hello'),2,3])).to.equal 'hello'
    expect(Util.firstValue([(-> ),(-> 2),3])).to.equal 2
    expect(Util.firstValue([(-> null),(-> 2),3])).to.equal null


# ----------------------------------------------------------------------

describe 'Util.isObject (true)', ->
  it 'is a literal object', ->
    expect(Util.isObject({})).to.equal true
    expect(Util.isObject({ foo:123 })).to.equal true

  it 'is a derived object', ->
    class Foo
    foo = new Foo()
    expect(Util.isObject(foo)).to.equal true


# ----------------------------------------------------------------------


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


# ----------------------------------------------------------------------


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


# ----------------------------------------------------------------------


describe 'Util.isNumeric', ->
  it 'is numeric (number)', ->
    expect(Util.isNumeric(0)).to.equal true
    expect(Util.isNumeric(1)).to.equal true
    expect(Util.isNumeric(-1)).to.equal true
    expect(Util.isNumeric(0.5)).to.equal true
    expect(Util.isNumeric(123456.123456)).to.equal true

  it 'is numeric (string)', ->
    expect(Util.isNumeric('0')).to.equal true
    expect(Util.isNumeric('1')).to.equal true
    expect(Util.isNumeric('-1')).to.equal true
    expect(Util.isNumeric('0.5')).to.equal true
    expect(Util.isNumeric('123456.123456')).to.equal true

  it 'is not numeric', ->
    expect(Util.isNumeric()).to.equal false
    expect(Util.isNumeric(null)).to.equal false
    expect(Util.isNumeric(undefined)).to.equal false
    expect(Util.isNumeric('string')).to.equal false
    expect(Util.isNumeric('123px')).to.equal false
    expect(Util.isNumeric({})).to.equal false
    expect(Util.isNumeric(new Date())).to.equal false


# ----------------------------------------------------------------------


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


# ----------------------------------------------------------------------


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



# ----------------------------------------------------------------------



describe 'Util.clone', ->
  it 'doees not clone nothing', ->
    expect(Util.clone()).to.equal undefined
    expect(Util.clone(null)).to.equal null

  it 'does not clone a string', ->
    expect(Util.clone('foo')).to.equal 'foo'

  it 'clones an Array', ->
    array = [1,2,3]
    cloned = Util.clone(array)
    expect(cloned).to.not.equal array
    expect(cloned).to.eql array

  it 'clones an Date', ->
    date = new Date()
    cloned = Util.clone(date)
    expect(cloned).to.not.equal date
    expect(cloned).to.eql date

  it 'deep clones an object', ->
    obj =
      array: [1,2,3]
      date: new Date()
      childObj: {}
    cloned = Util.clone(obj)

    expect(cloned.array).to.not.equal obj.array
    expect(cloned.array).to.eql obj.array

    expect(cloned.date).to.not.equal obj.date
    expect(cloned.date).to.eql obj.date

    expect(cloned.childObj).to.not.equal obj.childObj
    expect(cloned.childObj).to.eql obj.childObj


# ----------------------------------------------------------------------


describe 'Util.toId', ->
  it 'extracts the [.id]', ->
    expect(Util.toId({ id:1 })).to.equal 1
    expect(Util.toId({ id:2, _id:456 })).to.equal 2

  it 'extracts the [._id]', ->
    expect(Util.toId({ _id:1 })).to.equal 1

  it 'extracts [.id] from derived class', ->
    class Foo
      id: 1
    expect(Util.toId(new Foo())).to.equal 1

  it 'extracts [._id] from derived class', ->
    class Foo
      _id: 1
    expect(Util.toId(new Foo())).to.equal 1

  it 'extracts [.id] from derived class via function', ->
    class Foo
      id: -> 1
    expect(Util.toId(new Foo())).to.equal 1

  it 'extracts [._id] from derived class via function', ->
    class Foo
      _id: -> 1
    expect(Util.toId(new Foo())).to.equal 1



  it 'returns original value (primitive)', ->
    expect(Util.toId(1)).to.equal 1
    expect(Util.toId('a')).to.equal 'a'

  it 'returns primitive from function', ->
    expect(Util.toId(-> 1)).to.equal 1

  it 'returns object from function', ->
    expect(Util.toId(-> { id:1 })).to.equal 1
    expect(Util.toId(-> { _id:1 })).to.equal 1

