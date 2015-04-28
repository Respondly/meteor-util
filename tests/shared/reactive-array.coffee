describe 'ReactiveArray', ->
  array = null
  beforeEach -> array = new ReactiveArray()


  it 'is disposable', ->
    array.observe
      added:   (value, index) ->
      changed: (oldValue, newValue, index) ->
      removed: (value, index) ->
      moved:   (value, fromIndex, toIndex) ->

    array.dispose()
    expect(array.isDisposed).to.equal true
    expect(array.hash.isDisposed).to.equal true

    expect(array._handlers.added.isDisposed).to.equal true
    expect(array._handlers.changed.isDisposed).to.equal true
    expect(array._handlers.removed.isDisposed).to.equal true


  it 'has an array', ->
    expect(array.items).to.be.an.instanceOf Array


  it 'has a count of zero (0) by default', ->
    expect(array.count()).to.equal 0


# ----------------------------------------------------------------------


describe.client 'ReactiveArray.count', ->
  array = null
  count = null
  beforeEach ->
    array = new ReactiveArray()
    count = -1
    Deps.autorun -> count = array.count()
    expect(count).to.equal 0

  it 'when adding', (done) ->
    array.add('foo')
    Util.delay ->
      expect(count).to.equal 1
      done()

  it 'when removed', (done) ->
    array.add(1).add(2).removeAt(0)
    Util.delay ->
      expect(count).to.equal 1
      done()


# ----------------------------------------------------------------------



describe 'ReactiveArray: functional methods', ->
  it 'map', ->
    array = new ReactiveArray()
    array.add(1).add(2)
    result = array.map (value) -> { value:value }
    expect(result).to.eql [{ value:1 }, { value:2 }]

  it 'each', ->
    array = new ReactiveArray()
    result = []
    array.add(1).add(2)
    array.each (value) -> result.push(value)
    expect(result).to.eql [1,2]


# ----------------------------------------------------------------------


describe 'indexOf', ->
  array = null
  beforeEach -> array = new ReactiveArray()

  it 'find index from number', ->
    array.add(1).add(2).add(3).add(4)
    expect(array.indexOf(1)).to.equal 0
    expect(array.indexOf(3)).to.equal 2
    expect(array.indexOf(55)).to.equal -1

  it 'find index from function', ->
    array.add(1).add(2).add(3).add(4)
    index = array.indexOf (value) -> value is 3
    expect(index).to.equal 2

  it 'does not find index from function', ->
    array.add(1).add(2).add(3).add(4)
    index = array.indexOf (value) -> value is 99
    expect(index).to.equal -1


# ----------------------------------------------------------------------


describe 'adding', ->
  array = null
  beforeEach -> array = new ReactiveArray()

  it 'adds an item', ->
    expect(array.count()).to.equal 0
    array.add(1)
    expect(array.count()).to.equal 1

  it 'returns the array from the [add] method', ->
    expect(array.add(1).add(2)).to.equal array

  it 'adds via the "push" method', ->
    expect(array.count()).to.equal 0
    array.push(1)
    expect(array.count()).to.equal 1


# ----------------------------------------------------------------------


describe 'removeAt', ->
  array = null
  beforeEach -> array = new ReactiveArray()

  it 'returns the array from the [removeAt] method', ->
    array.add('a')
    expect(array.removeAt(-1)).to.equal array
    expect(array.removeAt(99)).to.equal array
    expect(array.removeAt(0)).to.equal array
    array.add('a').add('b').add('c')
    expect(array.removeAt(0,2)).to.equal array

  it 'removes the item at the given index', ->
    array.add(1).add(2).add(3)
    array.removeAt(1)
    expect(array.items.length).to.equal 2
    expect(array.count()).to.equal 2
    expect(array.item(0)).to.equal 1
    expect(array.item(1)).to.equal 3

  it 'does nothing when the index is not found', ->
    array.add(1).add(2).add(3)
    array.removeAt(3)
    array.removeAt(-1)
    expect(array.count()).to.equal 3

  it 'removes a range', ->
    array.add(1).add(2).add(3).add(4).add(5)
    expect(array.count()).to.equal 5
    array.removeAt(1,3)

    expect(array.items.length).to.equal 2
    expect(array.count()).to.equal 2
    expect(array.item(0)).to.equal 1
    expect(array.item(1)).to.equal 5


# ----------------------------------------------------------------------


describe 'remove', ->
  array = null
  beforeEach -> array = new ReactiveArray()

  it 'returns the array from the [removeAt] method', ->
    array.add('a')
    expect(array.remove(-1)).to.equal array
    expect(array.remove('a')).to.equal array

  it 'does nothing', ->
    array.add(1).add(2).add(3)
    array.remove()
    expect(array.count()).to.equal 3
    expect(array.item(0)).to.equal 1
    expect(array.item(1)).to.equal 2
    expect(array.item(2)).to.equal 3

  it 'removes a single item', ->
    array.add(1).add(2).add(3)
    array.remove(2)
    expect(array.count()).to.equal 2
    expect(array.item(0)).to.equal 1
    expect(array.item(1)).to.equal 3

  it 'removes multiple items (value)', ->
    array.add(1).add(2).add(3)
    array.remove(2,1,3)
    expect(array.count()).to.equal 0

  it 'removes multiple items (function)', ->
    array.add(1).add(2).add(3)
    array.remove (value) -> value > 1
    expect(array.count()).to.equal 1
    expect(array.item(0)).to.equal 1

  it 'removes the first matching value', ->
    array.add('a').add('a').add('a')
    array.remove('a')
    expect(array.count()).to.equal 2

  it 'removes no items (no-match)', ->
    array.add(1).add(2).add(3)
    array.remove('a')
    expect(array.count()).to.equal 3


describe '"item" and "itemAt" (alias)', ->
  array = null
  beforeEach -> array = new ReactiveArray()

  it 'returns no value', ->
    array.add(1).add(2).add(3)
    expect(array.item(3)).to.equal undefined
    expect(array.itemAt(3)).to.equal undefined

  it 'overwrites an existing value with "item"', ->
    array.add('a')
    array.item(0, 'foo')
    expect(array.items[0]).to.equal 'foo'
    expect(array.count()).to.equal 1
    expect(array.item(0)).to.equal 'foo'

  it 'overwrites an existing value with "itemAt"', ->
    array.add('a')
    array.itemAt(0, 'foo')
    expect(array.items[0]).to.equal 'foo'
    expect(array.count()).to.equal 1
    expect(array.itemAt(0)).to.equal 'foo'

  it 'sets a new value at the last item', ->
    array.add('a')
    array.item(99, 'foo')
    expect(array.count()).to.equal 2
    expect(array.items).to.eql ['a', 'foo']


# ----------------------------------------------------------------------


describe 'observe', ->
  array = null
  beforeEach -> array = new ReactiveArray()

  it 'creates handlers', ->
    array.observe
        added:   (value, index) ->
        changed: (oldValue, newValue, index) ->
        removed: (value, index) ->

    expect(array._handlers.added).to.be.an.instanceOf   Handlers
    expect(array._handlers.changed).to.be.an.instanceOf Handlers
    expect(array._handlers.removed).to.be.an.instanceOf Handlers


  it 'stores handlers', ->
    fnAdded = ->
    fnChanged = ->
    fnRemoved = ->
    array.observe
        added:   fnAdded
        changed: fnChanged
        removed: fnRemoved

    handlers = array._handlers
    expect(handlers.added.items[0].func).to.equal fnAdded
    expect(handlers.changed.items[0].func).to.equal fnChanged
    expect(handlers.removed.items[0].func).to.equal fnRemoved


# ----------------------------------------------------------------------


describe 'observe "added" callbacks', ->
  array = null
  beforeEach -> array = new ReactiveArray()

  it 'invokes the "added" callback', ->
    value = null
    index = null
    array.observe
      added: (v, i) ->
        value = v
        index = i

    array.add('a')
    expect(value).to.equal 'a'
    expect(index).to.equal 0

    array.add('b')
    expect(value).to.equal 'b'
    expect(index).to.equal 1

  it 'invokes the "added" callback if inserted via the "item" method', ->
    value = null
    index = null
    array.observe
      added: (v, i) ->
        value = v
        index = i
    array.item(0, 'a')
    expect(value).to.equal 'a'
    expect(index).to.equal 0


describe 'observe "removed" callbacks', ->
  array = null
  beforeEach -> array = new ReactiveArray()

  it 'invokes the "removed" callback when removing a single item', ->
    value = null
    index = null
    array.observe
      removed: (v, i) ->
        value = v
        index = i

    array.add('a').add('b').add('c').add('d')

    array.removeAt(0)
    expect(value).to.equal 'a'
    expect(index).to.equal 0

    array.removeAt(2)
    expect(value).to.equal 'd'
    expect(index).to.equal 2

  it 'invokes the "removed" callback multiple times when removing a range', ->
    values = []
    indexes = []
    array.observe
      removed: (v, i) ->
        values.push v
        indexes.push i

    array.add('a').add('b').add('c').add('d').add('e')
    array.removeAt(1,3)
    expect(values).to.eql ['b', 'c', 'd']
    expect(indexes).to.eql [1,2,3]


# ----------------------------------------------------------------------


describe 'observe "changed" callbacks', ->
  array = null
  beforeEach -> array = new ReactiveArray()

  it 'invokes the "changed" callback', ->
    oldValue = null
    newValue = null
    index = null
    array.observe
      changed: (o, n, i) ->
        oldValue = o
        newValue = n
        index = i
    array.add('a')
    array.item(0, 'b')

    expect(oldValue).to.equal 'a'
    expect(newValue).to.equal 'b'
    expect(index).to.equal 0
