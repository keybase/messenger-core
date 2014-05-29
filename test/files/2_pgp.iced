
main = require '../../lib/main'

msg = """
-----BEGIN PGP MESSAGE-----
Version: GnuPG/MacGPG2 v2.0.22 (Darwin)
Comment: GPGTools - https://gpgtools.org

hQEMA5gKPw0B/gTfAQf/WIbMs2bzQERC7GmFm9PSchULgwJNrgGMJXPJFzO/PnYG
EdKOpKZtnC99INbn23B5f8fIAxvtf2dvDsBDAhwiiU+9yIhZdTLuKsTjFi7ZJhoN
FweXPO9qTGtRcekVYB9jeM29nsxifDeKTw+aZ00GhaMDd67pnGBhkBmrDVflFuFE
Wd7IF6WJZC+B4MxbQ1v+rzpNQLZBJxd9m6WRuWZc+hcpu3CMhIvaM/HtyqzJRB78
TphPKV6VqVUSFDt9Whq3tOZ90gKaEGiX+k9hjInUccUcs10i0oKcwstw1uANAcmz
Me2HeqzT2Et1VaBSXTtCk6+D7QeyHwPQb5RYQOhCJdI9AWpNvUMvNIlyIlJLZKQx
BmbWSyhttDzBgNEufD916k/iUvo0MER8kPZDMqLPYjWUKxgorJxsvX6eDWJSaw==
=QlIG
-----END PGP MESSAGE-----
"""

exports.test_pgp = (T,cb) ->
  obj = null
  setter = (o) -> obj = o
  chk = main.pgp.checker(setter)
  err = chk msg
  T.no_error err
  T.assert obj?, "obj was set"
  T.assert obj.body?, "obj was a parse PGP obj"

  # A broken message with an inapproriate header
  msg2 = [ "----BEGIN PGP MESSAGE----"].concat((msg.split "\n")[1...]).join "\n"
  obj = null
  err = chk msg2
  T.assert err?, "error happened on broken PGP"
  T.assert not(obj?), "obj wasn't set"
  
  cb()