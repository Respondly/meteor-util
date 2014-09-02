describe 'toEdge', ->
  it 'is null if value is blank', ->
    expect(Util.toEdge(' ')).to.equal null
    expect(Util.toEdge()).to.equal null
    expect(Util.toEdge(null)).to.equal null

  it 'returns default axis if only one axis is specified', ->
    expect(Util.toEdge('right')).to.eql { x:'right', y:'top' }
    expect(Util.toEdge('bottom')).to.eql { x:'left', y:'bottom' }

  it 'top, left', ->
    expect(Util.toEdge('top, left')).to.eql { x:'left', y:'top' }
    expect(Util.toEdge('left,Top')).to.eql  { x:'left', y:'top' }

  it 'top, center', ->
    expect(Util.toEdge('top, center')).to.eql { x:'center', y:'top' }
    expect(Util.toEdge('center, top')).to.eql { x:'center', y:'top' }

  it 'handles all permutations', ->
    for x in ['left', 'center', 'right']
      for y in ['top', 'middle', 'bottom']
        expect(Util.toEdge("#{ x }, #{ y }")).to.eql { x:x, y:y }
        expect(Util.toEdge("#{ y }, #{ x }")).to.eql { x:x, y:y }
        expect(Util.toEdge("#{ x.toUpperCase() }, #{ y.toUpperCase() }")).to.eql { x:x, y:y }


# ----------------------------------------------------------------------


size = null
rect = null
initRelativePosition = ->
  size = { width:10, height:10 }
  rect = { width:100, height:200, left:50, top:100 }



describe 'relativePosition: align [x:y] inside (default)', ->
  beforeEach -> initRelativePosition()

  it 'top | left (default)', ->
    result = Util.relativePosition(size, rect) # edge:'top,left' by default.
    expect(result.left).to.equal 50
    expect(result.top).to.equal 100

  it 'top | center', ->
    result = Util.relativePosition(size, rect, edge:'center,top')
    expect(result.left).to.equal 50 + (100 / 2)
    expect(result.top).to.equal 100

  it 'middle | center', ->
    result = Util.relativePosition(size, rect, edge:'middle,center')
    expect(result.left).to.equal (50 + (100 / 2))
    expect(result.top).to.equal (100 + (200 / 2))

  it 'bottom | right', ->
    result = Util.relativePosition(size, rect, edge:'bottom,right')
    expect(result.left).to.equal (50 + 100) - 10
    expect(result.top).to.equal 100 + 200 - 10

  it 'bottom | center', ->
    result = Util.relativePosition(size, rect, edge:'bottom,center')
    expect(result.left).to.equal 50 + (100 / 2)
    expect(result.top).to.equal 100 + 200 - 10



describe 'relativePosition: align [x:y] center', ->
  beforeEach -> initRelativePosition()

  it 'top | left (default)', ->
    result = Util.relativePosition(size, rect, align:'center') # edge:'top,left' by default.
    expect(result.left).to.equal 45
    expect(result.top).to.equal 95

  it 'middle | center', ->
    result = Util.relativePosition(size, rect, edge:'middle,center', align:'center,center')
    expect(result.left).to.equal (50 + (100 / 2)) - 5
    expect(result.top).to.equal (100 + (200 / 2)) - 5

  it 'bottom | right', ->
    result = Util.relativePosition(size, rect, edge:'bottom,right', align:{ x:'center', y:'center' })
    expect(result.left).to.equal (50 + 100) - 5
    expect(result.top).to.equal 100 + 200 - 5



describe 'relativePosition: align [x:y] outside', ->
  beforeEach -> initRelativePosition()

  it 'top | left (default)', ->
    result = Util.relativePosition(size, rect, align:'outside') # edge:'top,left' by default.
    expect(result.left).to.equal 50 - 10
    expect(result.top).to.equal 100 - 10

  it 'top | right', ->
    result = Util.relativePosition(size, rect, edge:'top,right', align:'outside')
    expect(result.left).to.equal (50 + 100)
    expect(result.top).to.equal 100 - 10

  it 'middle | center', ->
    result = Util.relativePosition(size, rect, edge:'middle,center', align:'outside')
    expect(result.left).to.equal (50 + (100 / 2))
    expect(result.top).to.equal (100 + (200 / 2))

  it 'bottom | left', ->
    result = Util.relativePosition(size, rect, edge:'bottom,left', align:'outside')
    expect(result.left).to.equal (50 - 10)
    expect(result.top).to.equal 100 + 200

  it 'bottom | right', ->
    result = Util.relativePosition(size, rect, edge:'bottom,right', align:'outside')
    expect(result.left).to.equal (50 + 100)
    expect(result.top).to.equal 100 + 200





















