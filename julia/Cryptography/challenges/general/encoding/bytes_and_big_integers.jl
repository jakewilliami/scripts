#=
message: HELLO
ascii bytes: [72, 69, 76, 76, 79]
hex bytes: [0x48, 0x45, 0x4c, 0x4c, 0x4f]
base-16: 0x48454c4c4f
base-10: 310400273487
=#

input_int = BigInt(11515195063862318899931685488813747395775516287289682636499965282714637259206269)

function message2integer(message::String)
    ascii_bytes = Int[Int(c) for c in message]
    hex_bytes = UInt8[UInt8(a) for a in ascii_bytes] # or codeunits
    base16 = bytes2hex(H)
    base10 = BigInt(parse(UInt, base10))
    return base10
end

function integer2message(i::Integer)
    base16 = string(i, base = 16)
    hex_bytes = hex2bytes(base16)
    ascii_bytes = Int[Int(b) for b in hex_bytes]
    message = join(Char(a) for a in ascii_bytes) # this is faster though: `String(UInt8[UInt8(a) for a in A])`
    return message
end

println(integer2message(input_int))
