describe 'Delay (Timer)', ->
  it 'delays for a given amount of time', (done) ->
    startedAt = new Date()
    Util.delay 50, =>
        @try ->
          elapsed = startedAt.millisecondsAgo()
          expect(elapsed >= 50).to.equal true
        done()


  it 'has returns the timer ID', ->
    result = Util.delay 5, ->
    expect(result.id?).to.equal true


  it 'stops a timer', (done) ->
    wasCompleted = false
    result = Util.delay 10, -> wasCompleted = true
    result.stop()

    onTimeout = =>
        @try -> expect(wasCompleted).to.equal false
        done()
    Meteor.setTimeout(onTimeout, 50)






