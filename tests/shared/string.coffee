describe 'String: capitalize', ->
  capitalize = null
  beforeEach ->
    capitalize = Util.string.capitalize


  it 'does nothing with blank value', ->
    expect(capitalize()).to.equal undefined
    expect(capitalize(undefined)).to.equal undefined
    expect(capitalize(null)).to.equal null
    expect(capitalize('')).to.equal ''
    expect(capitalize('  ')).to.equal '  '


  it 'capitalizes first letter, and down-cases all other letters', ->
    expect(capitalize('hello Kitty', scope:'first')).to.equal 'Hello kitty'


  it 'capitalizes all letters', ->
    expect(capitalize('hello kitty', scope:'all')).to.equal 'Hello Kitty'


  it 'capitalizes first letter only (default)', ->
    expect(capitalize('hello kitty')).to.equal 'Hello kitty' # Default.
    expect(capitalize('hello kitty', scope:'firstOnly')).to.equal 'Hello kitty'
    expect(capitalize('hello Kitty', scope:'firstOnly')).to.equal 'Hello Kitty' # No change to rest of string.


  it 'capitalizes single character', ->
    expect(capitalize('h')).to.equal 'H'
    expect(capitalize('h', scope:'firstOnly')).to.equal 'H'
    expect(capitalize('h', scope:'first')).to.equal 'H'
    expect(capitalize('h', scope:'all')).to.equal 'H'



# ----------------------------------------------------------------------



describe 'String: plural', ->
  it 'returns the plural word', ->
    expect(Util.string.plural(0, 'item')).to.equal 'items'
    expect(Util.string.plural(2, 'item')).to.equal 'items'
    expect(Util.string.plural(-2, 'item')).to.equal 'items'
    expect(Util.string.plural(-1.5, 'item')).to.equal 'items'
    expect(Util.string.plural(1.5, 'item')).to.equal 'items'

  it 'returns the singular word', ->
    expect(Util.string.plural(1, 'item')).to.equal 'item'
    expect(Util.string.plural(-1, 'item')).to.equal 'item'



# ----------------------------------------------------------------------



describe 'String.replace', ->
  it 'replaces a single value', ->
    value = 'hello foo, how are you baz?'
    result = Util.string.replace(value, foo:123)
    expect(result).to.equal 'hello 123, how are you baz?'

  it 'replaces multilple values', ->
    value = 'hello foo, how are you baz?'
    result = Util.string.replace(value, foo:123, baz:'bar')
    expect(result).to.equal 'hello 123, how are you bar?'


