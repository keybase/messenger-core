
main = require '../../lib/main'

test_id_type = (T,type, cb) ->
  for i in [0...5]
    test_id T, type, i
  cb()

test_id = (T,type,i) ->
  cfg = main.const.id[type]
  id = main.id.generate cfg
  chk = main.id.checker(cfg)
  err = chk(id)
  T.no_error err
  T.waypoint "Check #{type} #{i}"

for k,v of main.const.id
  ((type) ->
    exports["test_#{type}"] = (T, cb) -> test_id_type T, type, cb
  )(k)

