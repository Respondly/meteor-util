ns = Util.html = {}


###
Performs basic HTML formatting for text.
###
ns.format = (text) ->
  html = ns.formatLines(text)
  html


###
Processes double line-breaks (\n) in a string into <p>'s.

    """
    Para1

    Para2
    """

@param text: The HTML text to format.
###
ns.formatLines = (text) ->
  return text unless text
  text = text.trim()
  html = ''

  # Paragraphs.
  for part in text.split('\n\n')
    html += "<p>#{ part }</p>"

  html




###
Formats brackets:

  << to: &lt;
  >> to: &gt;
###
ns.escapeBrackets = (text) ->
  if text
    text = text.replace(/<</g, '&lt;').replace(/>>/g, '&gt;')
  text
