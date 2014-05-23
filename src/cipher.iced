tsec                   = require 'triplesec'
{WordArray,hmac,prng}  = tsec
{AES}                  = tsec.ciphers
{CTR}                  = tsec.modes
{pack}                 = require 'purepack'
{bufeq_secure}         = require('iced-utils').util
C                      = require './const'

#==========================================================================================

class Key 

  @sizes : { HMAC : 32, AES : AES.keySize }
  sizes  : Key.sizes

  #-------

  constructor : ({@s, @m}) ->

  #-------

  generate : (cb) ->
    await prng.generate @sizes.HMAC, defer @m
    await prng.generate @sizes.AES, defer @s
    cb()

  #-------

  export_to_protocol :  -> { m : @m.to_buffer(), s : @s.to_buffer() }

#==========================================================================================

exports.Cipher = class Cipher

  @V : C.protocol.version.V1
  V : Cipher.V

  #---------

  constructor : ( {@key} ) ->
    @block_cipher = new AES @key.s

  #---------

  @generate_key : (cb) -> 
    key = new Key {}
    await key.generate defer()
    cb key

  #---------

  hmac : ({c,iv}, cb) ->
    buf = pack [ @V, c, iv ]
    await hmac.bulk_sign { key : @key.m, input : WordArray.from_buffer(buf) }, defer b
    cb b.to_buffer()

  #---------
  
  encrypt : (buf, cb) ->
    await prng.generate AES.ivSize, defer iv
    await CTR.bulk_encrypt { @block_cipher, iv, input : WordArray.from_buffer(buf) }, defer c
    c = c.to_buffer()
    iv = iv.to_buffer()
    await @hmac { c, iv }, defer m
    cb [ @V, c, iv, m ]

  #---------

  decrypt : ([v,c,iv,m], cb) ->
    err = ret = null
    if (v isnt @V) then err = new Error "Can only handle V1"
    else
      await @hmac { c, iv }, defer m2
      if not bufeq_secure m, m2
        err = new Error "HMAC mismatch"
      else
        args =  {
          @block_cipher,
          iv : WordArray.from_buffer(iv)
          input : WordArray.from_buffer(c)
        }
        await CTR.bulk_encrypt args, defer ret
        ret = ret.to_buffer()
    cb err, ret

  #---------
  
#==========================================================================================

