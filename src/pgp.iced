
pgpu = require 'pgp-utils'

#-------------------------------------------------------------------------------

exports.checker = (setter = null) -> (x) ->
  [err, res] = pgpu.armor.decode(x)
  if not err? and res? and setter? then setter(res)
  err

#-------------------------------------------------------------------------------
