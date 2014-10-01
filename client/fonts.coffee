# NOTE: Not using the [ClientSettings] object because this needs
#       to load immediately, and not wait for [Meteor.startup]
if families = __meteor_runtime_config__.CLIENT_SETTINGS?.font?.families
  window.WebFontConfig =
    google: { families: families }


  # See: JS section of a selected font on
  #      https://www.google.com/fonts
  do ->
    wf = document.createElement('script')
    wf.src = "#{ document.location.protocol }//ajax.googleapis.com/ajax/libs/webfont/1/webfont.js"
    wf.type = 'text/javascript'
    wf.async = 'true'
    s = document.getElementsByTagName('script')[0]
    s.parentNode.insertBefore(wf, s)


