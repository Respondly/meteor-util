describe 'ControllerBase', ->

  class MyController extends ControllerBase
  controller = null

  beforeEach ->
    controller = new MyController()


  it 'constructs with default values', ->
    expect(controller.hash).to.be.an.instanceOf ReactiveHash


  it 'has event API', ->
    expect(controller.trigger).to.be.an.instanceOf Function
    expect(controller.on).to.be.an.instanceOf Function
    expect(controller.off).to.be.an.instanceOf Function


