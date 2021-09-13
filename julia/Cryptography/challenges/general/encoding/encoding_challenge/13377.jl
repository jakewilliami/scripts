# this file is an attempted port of what is running on the server

using Sockets, Base64, ClassicalCiphers

FLAG = "crypto{????????????????????}"
ENCODINGS = [
    "base64",
    "hex",
    "rot13",
    "bigint",
    "utf-8",
]

open("/usr/share/dict/words") do io
    WORDS = [replace(strip(line), Char(0x0027) => "") for line in readlines(io)]
end

function from_bytes(::Type{T}, v::AbstractVector{UInt8}) where {T <: Base.BitInteger}
    mask = (0xff % T) << (8*sizeof(T) - 8)
    n = zero(T)
    for i in v
        iszero(n & mask) || throw(InexactError(:from_bytes, T, v))
        n = n << 8 | i
    end
    n
end
from_bytes(S::AbstractString) = from_bytes(UInt128, codeunits(S))
hex(S::AbstractString) = "0x" * bytes2hex(codeunits(S)) # this is just stored as a string

mutable struct Challenge
    challenge_words::String = ""
    stage::Int = 0
    exit::Bool
end

function create_level(C::Challenge)
    C.stage += 1
    C.challenge_words = join(rand(WORDS, 3), '_')
    encoding = rand(ENCODINGS)
    
    if encoding == "base64"
        encoded = Base64.base64encode(C.challenge_words)
    elseif encoding == "hex"
        encoded = bytes2hex(codeunits(C.challenge_words))
    elseif encoding == "rot13"
        encoded = encrypt_caesar(C.challenge_words, 13)
    elseif encoding == "bigint"
        encoded = hex(C.challenge_words)
    elseif encoding == "utf-8"
        encoded = Int8[Int8(c) for c in C.challenge_words]
    end
    
    return Dict{String, Union{String, Vector{UInt8}, Vector{Int8}}}(
        "type" => encoding,
        "encoded" => encoded
    )
end

function challenge(C::Challenge, your_input)
    if iszero(C.stage)
        return create_level(C)
    elseif C.stage == 100
        C.exit = true
        return Dict{String, String}("flag" => FLAG)
    end
    
    if C.challenge_words == your_input["decoded"]
        return create_level(C)
    end
    
    return Dict{String, String}("error" => "Decoding fail")
end

listen(13377)
