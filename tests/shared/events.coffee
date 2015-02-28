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
    triggerable.on 'ding', => expect(true).to.be.false;
    triggerable.off 'ding'
    triggerable.trigger('ding')
    Util.delay => done()
