ReactiveHash = Util.ReactiveHash



describe 'ReactiveHash: get/set', ->
  hash = null
  beforeEach -> hash = new ReactiveHash()


  it 'does not have the same set of keys', ->
    hash1 = new ReactiveHash()
    hash2 = new ReactiveHash()
    expect(hash1.keys).not.to.equal hash2.keys

  it 'sets a simple value', ->
    hash.set('foo', 1234)
    expect(hash.get('foo')).to.equal 1234
    expect(hash.keys.foo).to.equal 1234

  it 'sets a complex value (function)', ->
    fn = ->
    hash.set('foo', fn)
    expect(hash.get('foo')).to.equal fn
    expect(hash.keys.foo).to.equal fn

  it 'unsets a value', ->
    hash.set('foo', 1234)
    hash.unset('foo')
    expect(hash.keys.foo).to.equal undefined

  it 'clears all values', ->
    hash.set('foo', 123)
    hash.set('bar', 456)
    hash.clear()
    expect(hash.keys).to.eql {}



###
NOTE: Running only on client because of a fiber issue in the
      test-runner on the server.
###
describe.client 'ReactiveHash: reactivity', ->
  hash = null
  beforeEach -> hash = new ReactiveHash()

  it 'calls dependencies (only) when value is changed', (done) ->
    count = 0
    Deps.autorun =>
            hash.get('foo')
            count += 1

    count = 0
    hash.set 'foo', 'value'
    hash.set 'foo', 'value'
    hash.set 'foo', 'value'

    Util.delay 0, =>
      @try -> expect(count).to.equal 1
      done()


  it 'calls dependencies when value is unset', (done) ->
    count = 0
    Deps.autorun ->
            hash.get('key')
            count += 1

    count = 0
    hash.set('key', 'value1')

    Util.delay 0, =>
      hash.unset('key')

      Util.delay 0, =>
        @try -> expect(count).to.equal 2
        done()


  it 'calls dependencies when value is cleared', (done) ->
    hash.set 'foo', 123
    hash.set 'bar', 456
    fooCount = 0
    barCount = 0

    Deps.autorun ->
            hash.get('foo')
            fooCount += 1

    Deps.autorun ->
            hash.get('bar')
            barCount += 1

    Util.delay 0, =>
      hash.clear()
      Util.delay 0, =>
        @try ->
          expect(fooCount).to.equal 2
          expect(barCount).to.equal 2
        done()


  it 'calls dependencies when value is set to null', (done) ->
    hash.set 'foo', 123
    count = 0

    Deps.autorun ->
            hash.get('foo')
            count += 1

    Util.delay 0, =>
      hash.set 'foo', null
      Util.delay 0, =>
        @try ->
          expect(count).to.equal 2
        done()



#   it 'does not call dependency for other keys', (done) ->
#     count = 0
#     Deps.autorun -> count += 1

#     fn = ->
#       expect(count).to.equal 0
#       done()

#     count = 0
#     hash.set 'bar', 'value'
#     Meteor.setTimeout fn, 10


#   it 'call dependencies only when set value is changed ("onlyOnChange" on [options] parameter)', (done) ->
#     count = 0
#     Deps.autorun ->
#             hash.get('foo')
#             count += 1
#     count = 0

#     hash.set('foo', 123, onlyOnChange:true)
#     Util.delay -> hash.set('foo', 123, onlyOnChange:true)
#     Util.delay 5, -> hash.set('foo', 123, onlyOnChange:true)

#     Util.delay 10, ->
#       expect(count).to.equal 1
#       done()

#   it 'call dependencies only when set value is changed ("onlyOnChange" as default parameter)', (done) ->
#     hash.onlyOnChange = true
#     count = 0
#     Deps.autorun ->
#             hash.get('foo')
#             count += 1
#     count = 0

#     hash.set('foo', 123)
#     Util.delay -> hash.set('foo', 123)
#     Util.delay 5, -> hash.set('foo', 123)

#     Util.delay 10, ->
#       expect(count).to.equal 1
#       done()




describe 'ReactiveHash.prop', ->
  hash = null
  beforeEach -> hash = new ReactiveHash()


  it 'reads and write to the prop', ->
    fn = (value) -> hash.prop 'foo', value
    fn(123)
    expect(fn()).to.equal 123
    expect(hash.keys.foo).to.equal 123

  it 'has a default value', ->
    fn = (value) -> hash.prop 'foo', value, default:'hello'
    expect(fn()).to.equal 'hello'

  it 'has no default value', ->
    fn = (value) -> hash.prop 'foo', value
    expect(fn()).to.equal undefined



describe 'ReactiveHash.prop (reactivity)', ->
  hash = null
  beforeEach -> hash = new ReactiveHash()

  # it 'call dependencies on each change', (done) ->
  #   fn = (value) -> hash.prop 'foo', value
  #   count = 0
  #   Deps.autorun ->
  #           fn()
  #           count += 1
  #           done() if count is 2
  #   count = 0
  #   fn(123)
  #   Util.delay -> fn(123)

  # it 'call dependencies when set to null', (done) ->
  #   fn = (value) -> hash.prop 'foo', value
  #   count = 0
  #   Deps.autorun ->
  #           fn()
  #           count += 1
  #           done() if count is 2
  #   count = 0
  #   fn(123)
  #   Util.delay -> fn(null)


#     it 'call dependencies only when changed ("onlyOnChange" on [options] parameter)', (done) ->
#       fn = (value) -> hash.prop 'foo', value, onlyOnChange:true
#       count = 0
#       Deps.autorun ->
#               fn()
#               count += 1
#       count = 0

#       fn(123)
#       Util.delay -> fn(123)
#       Util.delay 5, -> fn(123)

#       Util.delay 10, ->
#         expect(count).to.equal 1
#         done()

#     it 'call dependencies only when changed ("onlyOnChange" as default parameter)', (done) ->
#       hash.onlyOnChange = true
#       fn = (value) -> hash.prop 'foo', value
#       count = 0
#       Deps.autorun ->
#               fn()
#               count += 1
#       count = 0

#       fn(123)
#       Util.delay -> fn(123)
#       Util.delay 5, -> fn(123)

#       Util.delay 10, ->
#         expect(count).to.equal 1
#         done()


describe 'storing objects with a [hash] property', ->
  hash = null
  beforeEach -> hash = new ReactiveHash()

  it 'disregards an object with a simple [hash] object property', ->
    # NB: Because this is noise passed back from a Handlebars call into the method.
    fn = (value) -> hash.prop 'foo', value
    fn(123)
    expect(fn()).to.equal 123
    fn({ hash:{} })
    expect(fn()).to.equal 123

  it 'stores a non-object [hash] property', ->
    # NB: Because this is noise passed back from a Handlebars call into the method.
    fn = (value) -> hash.prop 'foo', value
    obj = { hash:'abc' }
    fn(obj)
    expect(fn()).to.equal obj

  it 'stores a complex derived object [hash] property', ->
    # NB: Because this is noise passed back from a Handlebars call into the method.
    class Foo
    fn = (value) -> hash.prop 'foo', value
    foo = new Foo()
    obj = { hash:foo }
    fn(obj)
    expect(fn()).to.equal obj



describe 'ReactiveHash.dispose', ->
  hash = null
  beforeEach -> hash = new ReactiveHash()

  it 'is disposed', ->
    hash.dispose()
    expect(hash.isDisposed).to.equal true

  it 'clears values when disposed', ->
    hash.set 'foo', 1234
    hash.dispose()
    expect(hash.keys).to.eql {}
    expect(hash._deps).to.eql {}

  it 'stops reading values when disposed', ->
    hash.set 'foo', 1234
    hash.dispose()
    hash.get('foo')
    expect(hash._deps).to.eql {}

  it 'stops setting values when disposed', ->
    hash.dispose()
    hash.set('foo', 1234)
    expect(hash.keys).to.eql {}
    expect(hash._deps).to.eql {}

