describe 'Util.toCompoundValue', ->
  it 'returns [null] when no value or options are is passed', ->
    result = Util.toCompoundValue({ '0':'one', '1':'two' })
    expect(result).to.equal null

  it 'returns [null] when no value is passed', ->
    result = Util.toCompoundValue()
    expect(result).to.equal null

  it 'converts with two values', ->
    result = Util.toCompoundValue(1,true, { '0':'one', '1':'two' })
    expect(result.one).to.equal 1
    expect(result.two).to.equal true

  it 'reuses the first value', ->
    result = Util.toCompoundValue(1, { '0':'one', '1':'two' })
    expect(result.one).to.equal 1
    expect(result.two).to.equal 1

  it 'flattens arrays', ->
    result = Util.toCompoundValue([1,2], 3, { '0':'one', '1':'two', '3':'three' })
    expect(result.one).to.equal 1
    expect(result.two).to.equal 2
    expect(result.three).to.equal 3

  it 'reuses the last used value when not enough values are passed', ->
    result = Util.toCompoundValue('foo', 'bar', { '0':'one', '1':'two', '3':'three' })
    expect(result.one).to.equal 'foo'
    expect(result.two).to.equal 'bar'
    expect(result.three).to.equal 'bar'

  it 'does not convert an object', ->
    foo = { foo:'hello' }
    result = Util.toCompoundValue(foo, { '0':'one', '1':'two' })
    expect(result).to.equal foo



describe 'Util.toCompoundValue (string parsing)', ->
  it 'returns [null] when no value is passed', ->
    expect(Util.toCompoundValue('', { '0':'one' })).to.equal null
    expect(Util.toCompoundValue('  ', { '0':'one' })).to.equal null

  it 'parses a string of multiple values', ->
    result = Util.toCompoundValue('1,2 ,3,     4    ', { '0':'one', '1':'two', '2':'three' })
    expect(result.one).to.equal '1'
    expect(result.two).to.equal '2'
    expect(result.three).to.equal '3'
    expect(result.four).to.equal undefined # Final value was not declared in options).

  it 'reuses the first value', ->
    result = Util.toCompoundValue('1', { '0':'one', '1':'two' })
    expect(result.one).to.equal '1'
    expect(result.two).to.equal '1'

  it 'reuses the last used value when not enough values are passed', ->
    result = Util.toCompoundValue('1,2', { '0':'one', '1':'two', '3':'three' })
    expect(result.one).to.equal '1'
    expect(result.two).to.equal '2'
    expect(result.three).to.equal '2'


# ----------------------------------------------------------------------


describe 'Util.toCompoundNumber', ->
  it 'converts from string (single)', ->
    result = Util.toCompoundNumber('1', { '0':'one', '1':'two' })
    expect(result.one).to.equal 1
    expect(result.two).to.equal 1

  it 'converts from string (multiple)', ->
    result = Util.toCompoundNumber('1,2', { '0':'one', '1':'two' })
    expect(result.one).to.equal 1
    expect(result.two).to.equal 2

  it 'returns null when no value is passed', ->
    expect(Util.toCompoundNumber()).to.equal null
    expect(Util.toCompoundNumber('')).to.equal null
    expect(Util.toCompoundNumber('', { '0':'one', '1':'two' })).to.equal null
    expect(Util.toCompoundNumber('  ', { '0':'one', '1':'two' })).to.equal null

  it 'extracts unit values (% - single character)', ->
    result = Util.toCompoundNumber('100%', { '0':'x' })
    expect(result.x).to.equal 100
    expect(result.xUnit).to.equal '%'

  it 'extracts unit values (px - two characters)', ->
    result = Util.toCompoundNumber('100px', { '0':'x' })
    expect(result.x).to.equal 100
    expect(result.xUnit).to.equal 'px'


# ----------------------------------------------------------------------


describe 'Common compound values', ->
  it 'converts [toSize]', ->
    expect(Util.toSize(10, 20)).to.have.property 'width', 10
    expect(Util.toSize(10, 20)).to.have.property 'height', 20

    expect(Util.toSize(10)).to.have.property 'width', 10
    expect(Util.toSize(10)).to.have.property 'height', 10

    expect(Util.toSize('10')).to.have.property 'width', 10
    expect(Util.toSize('10')).to.have.property 'height', 10

    expect(Util.toSize('10, 20')).to.have.property 'width', 10
    expect(Util.toSize('10,20')).to.have.property 'height', 20

    expect(Util.toSize('auto, 10').width).to.equal undefined
    expect(Util.toSize('auto, 10').height).to.equal 10

    expect(Util.toSize('10,auto').width).to.equal 10
    expect(Util.toSize('10, auto').height).to.equal undefined

    expect(Util.toSize('10px,50').width).to.equal 10
    expect(Util.toSize('10em,50').widthUnit).to.equal 'em'

    expect(Util.toSize()).to.equal null
    expect(Util.toSize('  ')).to.equal null


  it 'converts [toSize].toStyle()', ->
    expect(Util.toSize(10, 20).toStyle()).to.equal "width:10px; height:20px;"
    expect(Util.toSize(10, 'auto').toStyle()).to.equal "width:10px;"
    expect(Util.toSize('auto', 10).toStyle()).to.equal "height:10px;"
    expect(Util.toSize('auto', 'auto').toStyle()).to.equal ""
    expect(Util.toSize(10, '20%').toStyle()).to.equal "width:10px; height:20%;"


  # ----------------------------------------------------------------------


  it 'converts [toPosition]', ->
    expect(Util.toPosition(10, 20)).to.have.property 'left', 10
    expect(Util.toPosition(10, 20)).to.have.property 'top', 20

    expect(Util.toPosition(10)).to.have.property 'left', 10
    expect(Util.toPosition(10)).to.have.property 'top', 10

    expect(Util.toPosition('10')).to.have.property 'left', 10
    expect(Util.toPosition('10')).to.have.property 'top', 10

    expect(Util.toPosition('10, 20')).to.have.property 'left', 10
    expect(Util.toPosition('10,20')).to.have.property 'top', 20

    expect(Util.toPosition()).to.equal null
    expect(Util.toPosition('  ')).to.equal null


  it 'converts [toPosition].toStyle()', ->
    expect(Util.toPosition(10, 20).toStyle()).to.equal "left:10px; top:20px;"
    expect(Util.toPosition('auto', 20).toStyle()).to.equal "top:20px;"


  # ----------------------------------------------------------------------


  it 'converts [toXY]', ->
    expect(Util.toXY(10, 20)).to.eql { x:10, y:20 }
    expect(Util.toXY(10)).to.eql { x:10, y:10 }
    expect(Util.toXY('10')).to.eql { x:10, y:10 }
    expect(Util.toXY('10, 20')).to.eql { x:10, y:20 }
    expect(Util.toXY('  ')).to.equal null
    expect(Util.toXY()).to.equal null


  # ----------------------------------------------------------------------


  it 'converts [toRect]', ->
    expect(Util.toRect(10, 20, 30, 40)).to.have.property 'left', 10
    expect(Util.toRect(10, 20, 30, 40)).to.have.property 'top', 20
    expect(Util.toRect(10, 20, 30, 40)).to.have.property 'width', 30
    expect(Util.toRect(10, 20, 30, 40)).to.have.property 'height', 40
    expect(Util.toRect('   ')).to.equal null
    expect(Util.toRect()).to.equal null


  it 'converts [toRect].toStyle()', ->
    expect(Util.toRect(10, 20, 30, 40).toStyle()).to.equal "left:10px; top:20px; width:30px; height:40px;"
    expect(Util.toRect(10, 'auto', 30, 40).toStyle()).to.equal "left:10px; width:30px; height:40px;"


  # ----------------------------------------------------------------------


  it 'converts [toSpacing]', ->
    expect(Util.toSpacing(10, 20, 30, 40)).to.have.property 'left', 10
    expect(Util.toSpacing(10, 20, 30, 40)).to.have.property 'top', 20
    expect(Util.toSpacing(10, 20, 30, 40)).to.have.property 'right', 30
    expect(Util.toSpacing(10, 20, 30, 40)).to.have.property 'bottom', 40
    expect(Util.toSpacing('   ')).to.equal null
    expect(Util.toSpacing()).to.equal null


  # ----------------------------------------------------------------------


  it 'converts [toAlignment]', ->
    expect(Util.toAlignment('center, middle')).to.have.property 'x', 'center'
    expect(Util.toAlignment('left,bottom')).to.have.property 'y', 'bottom'
    expect(Util.toAlignment('   ')).to.equal null
    expect(Util.toAlignment()).to.equal null

