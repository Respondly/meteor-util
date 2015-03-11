SECOND  = 1
MINUTE  = SECOND * 60
HOUR    = MINUTE * 60
DAY     = HOUR * 24
YEAR    = DAY * 365



describe 'Util.Date', ->
  now = null
  beforeEach ->
    now = new Date()

  describe 'formatElapsed: under a minute (just now)', ->
    it 'format:long (default)', ->
      JUST_NOW = 'just now'
      expect(Util.date.formatElapsed(0)).to.equal JUST_NOW
      expect(Util.date.formatElapsed(1)).to.equal JUST_NOW
      expect(Util.date.formatElapsed(59)).to.equal JUST_NOW

      expect(Util.date.formatElapsed(now)).to.equal JUST_NOW
      expect(Util.date.formatElapsed(now.rewind(seconds:1))).to.equal JUST_NOW
      expect(Util.date.formatElapsed(now.rewind(seconds:55))).to.equal JUST_NOW

    it 'format:short', ->
      NOW = 'now'
      expect(Util.date.formatElapsed(0, format:'short')).to.equal NOW
      expect(Util.date.formatElapsed(1, format:'short')).to.equal NOW
      expect(Util.date.formatElapsed(59, format:'short')).to.equal NOW


  describe 'formatElapsed: minutes', ->
    it 'format:long (default)', ->
      expect(Util.date.formatElapsed(60)).to.equal '1 minute'
      expect(Util.date.formatElapsed(now.rewind(seconds:60))).to.equal '1 minute'
      expect(Util.date.formatElapsed(90)).to.equal '2 minutes'
      expect(Util.date.formatElapsed(MINUTE * 59)).to.equal '59 minutes'

    it 'format:short', ->
      expect(Util.date.formatElapsed(60, format:'short')).to.equal '1m'
      expect(Util.date.formatElapsed(now.rewind(seconds:60), format:'short')).to.equal '1m'



  describe 'formatElapsed: hours', ->
    it 'format:long (default)', ->
      expect(Util.date.formatElapsed(MINUTE * 60)).to.equal '1 hour'
      expect(Util.date.formatElapsed(MINUTE * 61)).to.equal '1 hour'
      expect(Util.date.formatElapsed(MINUTE * 91)).to.equal '2 hours'
      expect(Util.date.formatElapsed((HOUR * 23) + 5)).to.equal '23 hours'
      expect(Util.date.formatElapsed(now.rewind(hours:21))).to.equal '21 hours'

    it 'format:short', ->
      expect(Util.date.formatElapsed(now.rewind(hours:21), format:'short')).to.equal '21h'
      expect(Util.date.formatElapsed(MINUTE * 91, format:'short')).to.equal '2h'



  describe 'formatElapsed: days', ->
    it 'format:long (default)', ->
      expect(Util.date.formatElapsed(HOUR * 24)).to.equal '1 day'
      expect(Util.date.formatElapsed((DAY * 364) + (HOUR * 2))).to.equal '364 days'

    it 'format:short', ->
      expect(Util.date.formatElapsed(HOUR * 24, format:'short')).to.equal '1d'



  describe 'formatElapsed: years', ->
    it 'format:long (default)', ->
      expect(Util.date.formatElapsed(YEAR)).to.equal '1 year'
      expect(Util.date.formatElapsed(YEAR + (30 * DAY))).to.equal '1 year'

    it 'format:short', ->
      expect(Util.date.formatElapsed(YEAR, format:'short')).to.equal '1y'



  describe 'formatElapsed: variant method: elapsed', ->
    it 'returns as parts', ->
      result = Util.date.elapsed(90)
      expect(result).to.be.an.instanceOf Object
      expect(result.value).to.equal 2
      expect(result.unit).to.equal 'minutes'
      expect(result.valueUnit).to.equal '2 minutes'
      expect(result.suffix).to.equal 'ago'
      expect(result.display).to.equal '2 minutes ago'

    it 'returns as parts (short)', ->
      result = Util.date.elapsed(90, format:'short')
      expect(result).to.be.an.instanceOf Object
      expect(result.value).to.equal 2
      expect(result.unit).to.equal 'm'
      expect(result.valueUnit).to.equal '2m'
      expect(result.suffix).to.equal 'ago'
      expect(result.display).to.equal '2m ago'

    it 'just now', ->
      result = Util.date.elapsed(20)
      expect(result.value).to.equal 20
      expect(result.valueUnit).to.equal '20 seconds'
      expect(result.display).to.equal 'just now'



  describe 'formatElapsed: variant method: elapsedAgo', ->
    it 'returns display string', ->
      expect(Util.date.elapsedAgo(90)).to.equal '2 minutes ago'

    it 'returns display string (short)', ->
      expect(Util.date.elapsedAgo(90, format:'short')).to.equal '2m ago'


  # ----------------------------------------------------------------------


  describe 'roundToHalfHour', ->
    it 'rounds down to 0 minutes', ->
      expect(Util.date.roundToHalfHour(Date.create('1pm')).getMinutes()).to.equal 0
      expect(Util.date.roundToHalfHour(Date.create('1:05pm')).getMinutes()).to.equal 0
      expect(Util.date.roundToHalfHour(Date.create('1:14:59pm')).getMinutes()).to.equal 0

    it 'rounds up to 30 minutes', ->
      expect(Util.date.roundToHalfHour(Date.create('1:15pm')).getMinutes()).to.equal 30
      expect(Util.date.roundToHalfHour(Date.create('1:29:59pm')).getMinutes()).to.equal 30
      expect(Util.date.roundToHalfHour(Date.create('1:30pm')).getMinutes()).to.equal 30

    it 'rounds down to 30 minutes', ->
      expect(Util.date.roundToHalfHour(Date.create('1:30pm')).getMinutes()).to.equal 30
      expect(Util.date.roundToHalfHour(Date.create('1:44:59pm')).getMinutes()).to.equal 30

    it 'rounds up to the next hour', ->
      expect(Util.date.roundToHalfHour(Date.create('1:45am')).getHours()).to.equal 2
      expect(Util.date.roundToHalfHour(Date.create('1:45am')).getMinutes()).to.equal 0

      expect(Util.date.roundToHalfHour(Date.create('1:59:59am')).getHours()).to.equal 2
      expect(Util.date.roundToHalfHour(Date.create('1:59:59am')).getMinutes()).to.equal 0
