describe 'Stampit.Events', ->
  triggerable = null

  beforeEach ->
    triggerable = Stamps.Events()

  it 'triggers an event', (done) ->
    triggerable.on 'ding', => done()
    triggerable.trigger('ding')

  it 'removes an event', (done) ->
    triggerable.on 'ding', => expect(true).to.be.false;
    triggerable.off 'ding'
    triggerable.trigger('ding')
    Util.delay 1000, => done()
