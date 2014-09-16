describe 'domainFromEmail', ->
  it 'retrieves the correct lowercased domain from the email', ->

    expectedResults =
      'Tim@favstar.fm': 'favstar.fm'
      'tim@favstar.FM': 'favstar.fm'
      'bob@myname.co.nz': 'myname.co.nz'

    _.keys(expectedResults).each (email) ->
      expect(Util.email.domainFromEmail(email)).to.equal expectedResults[email]

  it 'returns null when passed null', ->
    expect(Util.email.domainFromEmail(null)).to.equal null

  it 'returns null when passed empty string', ->
    expect(Util.email.domainFromEmail('')).to.equal null

  it 'throws an error if passed an email wrapped in <>', ->
    expect(Util.email.domainFromEmail('<a@b.com>')).to.equal null


# ----------------------------------------------------------------------


describe 'getNameFromEmail', ->
  it 'retrieves the correct name from the email', ->

    expectedResults =
      'Tim Haines <Tim@favstar.fm>': 'Tim Haines'
      '"Tim Haines" <tim@favstar.FM>': 'Tim Haines'
      '\'Tim Haines\' <tim@favstar.FM>': 'Tim Haines'
      'Bob<bob@myname.co.nz>': 'Bob'
      'm_leuker@t-online.de <m_leuker@t-online.de>': 'm_leuker@t-online.de'
      '"m_leuker@t-online.de" <m_leuker@t-online.de>': 'm_leuker@t-online.de'
      '\'m_leuker@t-online.de\' <m_leuker@t-online.de>': 'm_leuker@t-online.de'
      'tim@favstar.fm': 'tim'
      '<tim@favstar.fm>': 'tim'
      't@im@favstar.fm': 't'
      '<t@im@favstar.fm>': 't'

    _.keys(expectedResults).each (email) ->
      expect(Util.email.getNameFromEmail(email)).to.equal expectedResults[email]

  it 'returns string before the first @ if the email isn\'t wrapped in <>', ->
    expect(Util.email.getNameFromEmail('tim@favstar.fm')).to.equal 'tim'
    expect(Util.email.getNameFromEmail('tim@bob@favstar.fm')).to.equal 'tim'

  it 'does not modify the email passed in', ->
    email = '"Tim Haines" <tim@favstar.FM> '
    Util.email.getNameFromEmail(email)
    expect(email).to.equal '"Tim Haines" <tim@favstar.FM> '


# ----------------------------------------------------------------------


describe 'cleanEmail', ->
  it 'gets the email component from between the <>', ->

    expectedResults =
      'Tim Haines <Tim@favstar.fm>': 'Tim@favstar.fm'
      '"Tim Haines" <tim@favstar.FM>': 'tim@favstar.fm'
      '\'Tim Haines\' <tim@favstar.FM>': 'tim@favstar.fm'
      'Bob<bob@myname.co.nz>': 'bob@myname.co.nz'
      'm_leuker@t-online.de <m_leuker1@t-online.de>': 'm_leuker1@t-online.de'
      '"m_leuker@t-online.de" <m_leuker2@t-online.de>': 'm_leuker2@t-online.de'
      '\'m_leuker@t-online.de\' <m_leuker3@t-online.de>': 'm_leuker3@t-online.de'

    _.keys(expectedResults).each (email) ->
      expect(Util.email.cleanEmail(email)).to.equal expectedResults[email]


  it 'lowercases the domain', ->

    expectedResults =
      'Tim Haines <Tim@favstar.fm>': 'Tim@favstar.fm'
      'Tim Haines <Tim@FavStar.fm>': 'Tim@favstar.fm'
      'Tim Haines <Tim@favstar.FM>': 'Tim@favstar.fm'
      'Tim@favstar.fm': 'Tim@favstar.fm'
      'Tim@FavStar.fm': 'Tim@favstar.fm'
      'Tim@favstar.FM': 'Tim@favstar.fm'
      'T@im@FavStar.fm': 'T@im@favstar.fm'

    _.keys(expectedResults).each (email) ->
      expect(Util.email.cleanEmail(email)).to.equal expectedResults[email]


  it 'respects the case of the username', ->
    expectedResults =
      'Tim Haines <Tim@favstar.fm>': 'Tim@favstar.fm'
      'Tim Haines <tim@FavStar.fm>': 'tim@favstar.fm'
      'Tim Haines <TiM@favstar.FM>': 'TiM@favstar.fm'

    _.keys(expectedResults).each (email) ->
      expect(Util.email.cleanEmail(email)).to.equal expectedResults[email]

  it 'trims whitespace', ->
    expectedResults =
      ' Tim@favstar.fm ': 'Tim@favstar.fm'
      ' Tim Haines <tim@FavStar.fm>  ': 'tim@favstar.fm'

    _.keys(expectedResults).each (email) ->
      expect(Util.email.cleanEmail(email)).to.equal expectedResults[email]

  it 'does not modify the email passed in', ->
    email = '"Tim Haines" <tim@favstar.FM> '
    Util.email.cleanEmail(email)
    expect(email).to.equal '"Tim Haines" <tim@favstar.FM> '
