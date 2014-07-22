describe 'LocalStorage.prop', ->
  beforeEach -> localStorage.removeItem('foo')
  afterEach -> localStorage.removeItem('foo')

  it 'reads and writes to the prop (string)', ->
    fn = (value) -> LocalStorage.prop 'foo', value, default:'hello'
    fn('hello')
    expect(fn()).to.equal 'hello'

    fn(undefined) # No change.
    expect(fn()).to.equal 'hello'


  it 'has a default value', ->
    fn = (value) -> LocalStorage.prop 'foo', value, default:'hello'
    expect(fn()).to.equal 'hello'


  it 'has no default value', ->
    fn = (value) -> LocalStorage.prop 'foo', value
    expect(fn()).to.equal undefined




describe 'LocalStorage.prop (Data Types)', ->
  myProp = (value) -> LocalStorage.prop 'foo', value
  afterEach -> localStorage.removeItem('foo')

  it 'null', ->
    myProp('hello')
    myProp(null)
    expect(myProp()).to.equal null


  it 'bool', ->
    myProp(true)
    expect(myProp()).to.equal true


  it 'string', ->
    myProp('my value')
    expect(myProp()).to.equal 'my value'

    myProp('  ')
    expect(myProp()).to.equal '  '

    myProp('')
    expect(myProp()).to.equal ''


  it 'number', ->
    myProp(0)
    expect(myProp()).to.equal 0

    myProp(3.14159265359)
    expect(myProp()).to.equal 3.14159265359

    myProp(-1)
    expect(myProp()).to.equal -1


  it 'object', ->
    myProp({})
    expect(myProp()).to.eql {}
    myProp({ number:12.5, text:'string', obj:{}, bool:true })
    expect(myProp()).to.eql { number:12.5, text:'string', obj:{}, bool:true }

