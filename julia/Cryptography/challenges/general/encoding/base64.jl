using Base64

b64 = "72bca9b68fc16ac7beeb8f849dca1d8a783e8acf9679bf9269f7bf"
hex_decoded = String(hex2bytes(b64))

println(Base64.base64encode(hex_decoded))
