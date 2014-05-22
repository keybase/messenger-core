
{Cipher} = require '../../lib/main'
{prng} = require 'crypto'
{bufeq_fast} = require('iced-utils').util

exports.test_cipher = (T,cb) ->
  dat = prng(383)
  await Cipher.generate_key defer key
  cipher = new Cipher { key }
  await cipher.encrypt dat, defer ctext
  T.assert ctext?, "cipher came back"
  await cipher.decrypt ctext, defer err, dat2
  T.no_error err
  T.assert dat2?, "dat2 came back"
  T.assert dat, dat2, "the right data came back"
  ctext[1][4] ^= 0x4f
  await cipher.decrypt ctext, defer err, dat3
  T.assert err?, "An error came back"
  T.equal err.message, "HMAC mismatch", "right error message"
  ctext[1][4] ^= 0x4f
  ctext[3][4] ^= 0x4f
  await cipher.decrypt ctext, defer err, dat4
  T.assert err?, "An error came back"
  T.equal err.message, "HMAC mismatch", "right error message"
  cb()