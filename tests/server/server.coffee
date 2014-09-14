describe 'Server.isDev', ->
  ORIGINAL_VALUE = null

  # Store and reset the orignal DEV_SERVER value.
  beforeEach -> ORIGINAL_VALUE = process.env.DEV_SERVER
  afterEach -> process.env.DEV_SERVER = ORIGINAL_VALUE

  it 'is not a dev machine by default (when the environment var is not set)', ->
    delete process.env.DEV_SERVER
    expect(Server.isDev()).to.equal false

  it 'is not a dev machine (DEV_SERVER == false)', ->
    process.env.DEV_SERVER = false
    expect(Server.isDev()).to.equal false

    process.env.DEV_SERVER = 'false'
    expect(Server.isDev()).to.equal false

  it 'is a dev machine (DEV_SERVER == true)', ->
    process.env.DEV_SERVER = true
    expect(Server.isDev()).to.equal true

    process.env.DEV_SERVER = 'true'
    expect(Server.isDev()).to.equal true



