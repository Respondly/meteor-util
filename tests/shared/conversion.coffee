describe 'isTrue', ->
  it 'is true', ->
    expect(Util.isTrue(true)).to.equal true
    expect(Util.isTrue('true')).to.equal true
    expect(Util.isTrue(undefined, default:true)).to.equal true

  it 'is not true', ->
    expect(Util.isTrue(false)).to.equal false
    expect(Util.isTrue('false')).to.equal false
    expect(Util.isTrue()).to.equal false
    expect(Util.isTrue(undefined)).to.equal false
    expect(Util.isTrue(null)).to.equal false

describe 'isFalse', ->
  it 'is false', ->
    expect(Util.isFalse(false)).to.equal true
    expect(Util.isFalse('false')).to.equal true
    expect(Util.isFalse(undefined, default:true)).to.equal true

  it 'is not false', ->
    expect(Util.isFalse(true)).to.equal false
    expect(Util.isFalse('true')).to.equal false
    expect(Util.isFalse()).to.equal false
    expect(Util.isFalse(undefined)).to.equal false
    expect(Util.isFalse(null)).to.equal false


describe 'toBool: existing Boolean value', ->
  it 'true (no change)', ->
    expect(Util.toBool(true)).to.equal true

  it 'false (no change)', ->
    expect(Util.toBool(false)).to.equal false

describe 'toBool: string to Boolean', ->
  it 'converts "true" (string) to true', ->
    expect(Util.toBool('true')).to.equal true
    expect(Util.toBool('True')).to.equal true
    expect(Util.toBool('   truE   ')).to.equal true

  it 'converts "false" (string) to false', ->
    expect(Util.toBool('false')).to.equal false
    expect(Util.toBool('False')).to.equal false
    expect(Util.toBool('   falSe   ')).to.equal false

it 'does not convert other value types', ->
  expect(Util.toBool()).to.equal undefined
  expect(Util.toBool(null)).to.equal null
  expect(Util.toBool('Foo')).to.equal 'Foo'
  expect(Util.toBool('')).to.equal ''
  expect(Util.toBool(' ')).to.equal ' '
  expect(Util.toBool(123)).to.equal 123
  expect(Util.toBool({foo:123})).to.eql {foo:123}
