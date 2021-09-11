struct BitString
    data::Vector{UInt8}
    padding_bits::UInt8 # Will always be in [0, 8)
    
    function BitString(data::Vector{UInt8}, padding_bits::UInt8)
        if padding_bits > 7 || (isempty(data) && !iszero(padding_bits))
            error("Invalid")
        end
        if padding_bits > 0 && !iszero(data[end] & ((1 << padding_bits) - 1))
            error("Invalid")
        end
        return new(data, padding_bits)
    end
end

# Returns a sequence of bytes representing the data in the `BIT STRING`. Padding bits will
# always be 0.
function Base.codeunits(bitstr::BitString)
    return bitstr.data
end

# Returns whether the requested bit is set. Padding bits will always return false and
# asking for bits that exceed the length of the bit string will also return false.
function has_bit_set(bitstr::BitString, n::UInt)
    idx = n / 8
    v = 1 << (7 - (n & 0x07))
    return length(bitstr.data) < idx ? false : !iszero(bitstr.data[idx] & v)
end

