using Base64

### Base64 -> *

function base642hex(bytes::Vector{UInt8})
    decoded_bytes = Base64.base64decode(bytes)
    return bytes2hex(decoded_bytes)
end
function base642hex(S::String)
    bytes = Base64.base64decode(S)
    return bytes2hex(bytes)
end

function base642utf8(bytes::Vector{UInt8})
    decoded_bytes = Base64.base64decode(bytes)
    return Int8[Int8(b) for b in decoded_bytes]
end
function base642utf8(S::String)
    bytes = Base64.base64decode(S)
    return Int8[Int8(b) for b in decoded_bytes]
end

function base642string(bytes::Vector{UInt8})
    decoded_bytes = Base64.base64decode(bytes)
    return String(decoded_bytes)
end
function base642string(S::String)
    bytes = Base64.base64decode(S)
    return String(bytes)
end

function base642bytes end

### Hex -> *

function hex2base64(hexstring::String)
    bytes = hex2bytes(hexstring)
    return Base64.base64encode(bytes)
end

function hex2utf8(hexstring::String)
    bytes = hex2bytes(hexstring)
    return Int8[Int8(b) for b in hex_bytes]
end

function hex2string(hexstring::String)
    bytes = hex2bytes(hexstring)
    return String(bytes)
end

### BigInt -> *; * -> BigInt

# function base642bigint end
# function hex2bigint end
# function utf82bigint end
# function string2bigint end
# function bytes2bigint end
# function bigint2base64 end
# function bigint2hex end
# function bigint2utf8 end
# function bigint2string end

### UTF-8 -> *

function utf82base64(utf_bytes::Vector{Int8})
    return Base64.base64encode(utf_bytes)
end

function utf82hex(utf_bytes::Vector{Int8})
    bytes = UInt8[UInt8(b) for b in utf_bytes]
    return bytes2hex(bytes)
end

function utf82string(utf_bytes::Vector{Int8})
    bytes = UInt8[UInt8(b) for b in utf_bytes]
    return String(bytes)
end

function utf82bytes(utf_bytes::Vector{Int8})
    return UInt8[UInt8(b) for b in utf_bytes]
end

### String -> *

function string2base64(S::String)
    bytes = codeunits(S)
    return Base64.base64encode(bytes)
end

function string2hex(S::String)
    bytes = codeunits(S)
    return bytes2hex(bytes)
end

function string2utf8(S::String)
    return Int8[Int8(c) for c in Char]
end

function string2bytes(S::String)
    return Vector{UInt8}(codeunits(S))
end

### Bytes -> *

function bytes2base64(bytes::Vector{UInt8})
    return Base64.base64encode(bytes)
end

function bytes2utf8(bytes::Vector{UInt8})
    return Int8[Int8(b) for b in bytes]
end

function bytes2string(bytes::Vector{UInt8})
    return String(bytes)
end

