#= base
#= require ./classes/reactive-hash

###
The global [APP] is reserved for use by a consuming Meteor application.

NOTES:

  Some common state methods are decalred here on the APP object
  for use by common controls. Beyond these methods, do not use
  put anything on the APP object as this is the parlance of
  the consuming Meteor application.

  The [APP.ns] method exists for legacy reason, try not to use it
  unless working with legacy code (written prior to the creation of
  Meteor's package namespacing system).

###

@APP = APP = {}
cache = {}
APP.hash = hash = new ReactiveHash()


# ----------------------------------------------------------------------


###
Safely creates the given namespace on the root APP object.
@param namespace: The dot-delimited NS string (excluding the root 'APP').
@returns the child object of the namespace.
###
APP.ns = (namespace, root = APP) ->

  # Check whether the NS has already been created.
  cached = cache[namespace]
  return cached if cached?

  # Build the namespace.
  result = Util.ns.get(root, namespace)

  # Finish up.
  cache[namespace] = result
  result


# ----------------------------------------------------------------------


###
Gets or sets whether the APP is initialized.
@returns boolean.
###
APP.isInitialized = (value) -> hash.prop 'isInitialized', value, default:false
