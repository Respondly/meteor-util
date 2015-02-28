describe 'Stampit.Events', ->
  triggerable = null

  beforeEach ->
    triggerable = Stamps.Events()

  it 'triggers an event', (done) ->
    eventData = {hello: true}
    triggerable.on 'ding', (j, e) =>
      expect(e).to.be.eql(eventData)
      done()

    triggerable.trigger('ding', eventData)

  it 'removes an event', (done) ->
    # if on get's triggered expect something that will always fail
    triggerable.on 'ding', => throw new Error("This should not be called")
    triggerable.off 'ding'
    triggerable.trigger('ding')
    Util.delay 100, => done()
