Util.path = ns = {}



###
Creates a URL path to an image contained within a package.
@param packageName: The name of the package the image is contained within.
@param path:        The path to the image file.
@param a formatted path.
###
ns.packageImage = (packageName, path) ->
  packageName = packageName.replace(':', '_')
  path = path.remove(/^\/*/).remove(/^images\//)
  "/packages/#{ packageName }/images/#{ path }"
