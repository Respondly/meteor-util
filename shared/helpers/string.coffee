# See also the String functions in Sugar.js
# http://sugarjs.com/api
ns = Util.string = {}


###
Converts a singular word into it's plural depending
on the given number.
@param number:        The number of items to evaluate.
@param singularWord:  The word in it's singular form.
@returns the resulting word.
###
ns.plural = (number, singularWord) ->
  if number is 1 or number is -1
    singularWord
  else
    singularWord.pluralize()


###
Escapes < and > characters to their safe equivalents.
###
ns.escapeHtml = (text) ->
  if text
    text.replace(/&/g,  '&amp;' ).
      replace(/</g,  '&lt;'  ).
      replace(/>/g,  '&gt;'  ).
      replace(/"/g,  '&quot;').
      replace(/'/g,  '&apos;')
  else text




###
Performs multiple replace operations on a string.
@param string:        The source string to perform the replacements on.
@param replacements:  An object containing the replacement information.
                      The method finds all values within the string that match each key
                      replacing them with that value.

                        {
                          <find>: <replace with value>
                        }

@returns the string with all the replacements made.
###
ns.replace = (string, replacements = {}) ->
  for own key, value of replacements
    if value || value == ''
      regex = new RegExp(key, 'g')
      string = string.replace(regex, value)
  string



###
Capitalizes word(s) within the given text.
@param options:
          scope:
            - 'firstOnly':  Only the first letter is calitalized.  'hello kitty' => 'Hello Kitty'
            - 'first':      The first letter is calitalized and all subsequent letters are down-cased.
            - 'all':        All words are capitalized.
###
ns.capitalize = (text, options = {}) ->
  return text if Util.isBlank(text)
  scope = options.scope ? 'firstOnly'
  switch scope
    when 'all'       then text.capitalize(true)
    when 'first'     then text.capitalize(false)
    when 'firstOnly' then text[0].toUpperCase() + text.substring(1, text.length )
    else text

