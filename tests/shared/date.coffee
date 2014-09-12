SECOND  = 1
MINUTE  = SECOND * 60
HOUR    = MINUTE * 60
DAY     = HOUR * 24
YEAR    = DAY * 365


dateUtil = Util.date
formatElapsed = Util.date.formatElapsed
now = null


init = ->
  now = new Date()



describe 'Date - formatElapsed: under a minute (just now)', ->
  beforeEach -> init()

  it 'format:long (default)', ->
    JUST_NOW = 'just now'
    expect(formatElapsed(0)).to.equal JUST_NOW
    expect(formatElapsed(1)).to.equal JUST_NOW
    expect(formatElapsed(59)).to.equal JUST_NOW

    expect(formatElapsed(now)).to.equal JUST_NOW
    expect(formatElapsed(now.rewind(seconds:1))).to.equal JUST_NOW
    expect(formatElapsed(now.rewind(seconds:55))).to.equal JUST_NOW

  it 'format:short', ->
    NOW = 'now'
    expect(formatElapsed(0, format:'short')).to.equal NOW
    expect(formatElapsed(1, format:'short')).to.equal NOW
    expect(formatElapsed(59, format:'short')).to.equal NOW


describe 'Date - formatElapsed: minutes', ->
  beforeEach -> init()

  it 'format:long (default)', ->
    expect(formatElapsed(60)).to.equal '1 minute'
    expect(formatElapsed(now.rewind(seconds:60))).to.equal '1 minute'
    expect(formatElapsed(90)).to.equal '2 minutes'
    expect(formatElapsed(MINUTE * 59)).to.equal '59 minutes'

  it 'format:short', ->
    expect(formatElapsed(60, format:'short')).to.equal '1m'
    expect(formatElapsed(now.rewind(seconds:60), format:'short')).to.equal '1m'



describe 'Date - formatElapsed: hours', ->
  beforeEach -> init()

  it 'format:long (default)', ->
    expect(formatElapsed(MINUTE * 60)).to.equal '1 hour'
    expect(formatElapsed(MINUTE * 61)).to.equal '1 hour'
    expect(formatElapsed(MINUTE * 91)).to.equal '2 hours'
    expect(formatElapsed((HOUR * 23) + 5)).to.equal '23 hours'
    expect(formatElapsed(now.rewind(hours:21))).to.equal '21 hours'


  it 'format:short', ->
    expect(formatElapsed(now.rewind(hours:21), format:'short')).to.equal '21h'
    expect(formatElapsed(MINUTE * 91, format:'short')).to.equal '2h'



describe 'Date - formatElapsed: days', ->
  beforeEach -> init()

  it 'format:long (default)', ->
    expect(formatElapsed(HOUR * 24)).to.equal '1 day'
    expect(formatElapsed((DAY * 364) + (HOUR * 2))).to.equal '364 days'

  it 'format:short', ->
    expect(formatElapsed(HOUR * 24, format:'short')).to.equal '1d'



describe 'Date - formatElapsed: years', ->
  beforeEach -> init()

  it 'format:long (default)', ->
    expect(formatElapsed(YEAR)).to.equal '1 year'
    expect(formatElapsed(YEAR + (30 * DAY))).to.equal '1 year'

  it 'format:short', ->
    expect(formatElapsed(YEAR, format:'short')).to.equal '1y'



describe 'Date - formatElapsed: variant method: elapsed', ->
  beforeEach -> init()

  it 'returns as parts', ->
    result = dateUtil.elapsed(90)
    expect(result).to.be.an.instanceOf Object
    expect(result.value).to.equal 2
    expect(result.unit).to.equal 'minutes'
    expect(result.valueUnit).to.equal '2 minutes'
    expect(result.suffix).to.equal 'ago'
    expect(result.display).to.equal '2 minutes ago'

  it 'returns as parts (short)', ->
    result = dateUtil.elapsed(90, format:'short')
    expect(result).to.be.an.instanceOf Object
    expect(result.value).to.equal 2
    expect(result.unit).to.equal 'm'
    expect(result.valueUnit).to.equal '2m'
    expect(result.suffix).to.equal 'ago'
    expect(result.display).to.equal '2m ago'

  it 'just now', ->
    result = dateUtil.elapsed(20)
    expect(result.value).to.equal 20
    expect(result.valueUnit).to.equal '20 seconds'
    expect(result.display).to.equal 'just now'



describe 'Date - formatElapsed: variant method: elapsedAgo', ->
  beforeEach -> init()

  it 'returns display string', ->
    expect(dateUtil.elapsedAgo(90)).to.equal '2 minutes ago'

  it 'returns display string (short)', ->
    expect(dateUtil.elapsedAgo(90, format:'short')).to.equal '2m ago'



# ----------------------------------------------------------------------



describe 'roundToHalfHour', ->
  it 'rounds down to 0 minutes', ->
    expect(dateUtil.roundToHalfHour(Date.create('1pm')).getMinutes()).to.equal 0
    expect(dateUtil.roundToHalfHour(Date.create('1:05pm')).getMinutes()).to.equal 0
    expect(dateUtil.roundToHalfHour(Date.create('1:14:59pm')).getMinutes()).to.equal 0

  it 'rounds up to 30 minutes', ->
    expect(dateUtil.roundToHalfHour(Date.create('1:15pm')).getMinutes()).to.equal 30
    expect(dateUtil.roundToHalfHour(Date.create('1:29:59pm')).getMinutes()).to.equal 30
    expect(dateUtil.roundToHalfHour(Date.create('1:30pm')).getMinutes()).to.equal 30

  it 'rounds down to 30 minutes', ->
    expect(dateUtil.roundToHalfHour(Date.create('1:30pm')).getMinutes()).to.equal 30
    expect(dateUtil.roundToHalfHour(Date.create('1:44:59pm')).getMinutes()).to.equal 30

  it 'rounds up to the next hour', ->
    expect(dateUtil.roundToHalfHour(Date.create('1:45am')).getHours()).to.equal 2
    expect(dateUtil.roundToHalfHour(Date.create('1:45am')).getMinutes()).to.equal 0

    expect(dateUtil.roundToHalfHour(Date.create('1:59:59am')).getHours()).to.equal 2
    expect(dateUtil.roundToHalfHour(Date.create('1:59:59am')).getMinutes()).to.equal 0



