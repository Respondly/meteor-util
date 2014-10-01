html = Util.html


describe 'escapeBrackets', ->
  it 'converts << into &lt;', ->
    expect(html.escapeBrackets('foo << bar')).to.equal 'foo &lt; bar'

  it 'converts << into &gt;', ->
    expect(html.escapeBrackets('foo >> bar')).to.equal 'foo &gt; bar'

  it 'does not convert a plain <element> with single bracket (ie. not a double <<)', ->
    expect(html.escapeBrackets('<div>foo</div>')).to.equal '<div>foo</div>'



# ----------------------------------------------------------------------



describe 'formatLines', ->
  it 'converts to a single <p> element', ->
    source =
      """


      foo
      """

    expect(html.formatLines(source)).to.equal '<p>foo</p>'


  it 'converts to two <p> elements', ->
    source =
      """


      para1

      para2



      """
    expect(html.formatLines(source)).to.equal '<p>para1</p><p>para2</p>'



