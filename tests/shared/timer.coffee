describe 'Delay (Timer)', ->
  startedAt = null
  beforeEach -> startedAt = new Date()


  it 'delays for a given amount of time', (done) ->
    Util.delay 50, =>
        elapsed = startedAt.millisecondsAgo()
        expect(elapsed >= 50).to.equal true
        if elapsed >=50
          conosole.error "only", elapsed, "ms elapsed"
        done()


  it 'returns details about the timer', ->
    result = Util.delay 5, ->
    expect(result.id?).to.equal true
    expect(result.msecs).to.equal 5


  it 'stops a timer', (done) ->
    wasCompleted = false
    result = Util.delay 10, -> wasCompleted = true
    result.stop()

    onTimeout = =>
        expect(wasCompleted).to.equal false
        done()
    Meteor.setTimeout(onTimeout, 50)


  it 'delays for 0-msecs when no value supplied', ->
    result = Util.delay ->
    expect(result.msecs).to.equal 0
