struct ObjectIdentifier
    der_encoded::Vector{UInt8}
end

function read_base128_int(reader::Vector{UInt8})::Union{UInt32, Nothing}
    ret = UInt32(0)
    for i in 1:4
        b = reader[i]
        ret <<= 7
        ret |= UInt32(b & 0x7f)
        if iszero(b & 0x80)
            return ret
        end
    end
    return nothing
end
