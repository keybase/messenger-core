module.exports = 
  protocol :
    version : 
      V1 : 1
  id :
    thread : 
      byte_length : 16
      lsb : "00"
    write_token :
      byte_length : 16
      lsb : "01"
    sct :
      byte_length : 16
      lsb : "02"
    session : 
      byte_length : 16
      lsb : "02"

