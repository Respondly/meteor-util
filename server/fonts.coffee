Fonts = {} unless Fonts?
fontFamilies = []


###
Defines a set of web-fonts.
@param families: An array of font families
###
Fonts.define = (families...) ->
  # Build up the array of families.
  fontFamilies.push(family) for family in families
  fontFamilies = fontFamilies.unique()

  # Send font settings to the client.
  font = { families: fontFamilies }
  ClientSettings.set
    font: font

  # Finish up.
  font
