#=
struct BitIterator{T}
    val::T
    # function BitIterator(val::T) where T
    #     if T <: Integer
    #         return new{T}(val)
    #     elseif T <: AbstractChar
    #         return new{T}(UInt8(val))
    #     end
    # end
end
Base.length(::BitIterator{T}) where {T} = (sizeof(T) * 8)
Base.length(::Type{BitIterator{T}}) where {T} = (sizeof(T) * 8)
function Base.iterate(S::BitIterator{T}, i = 1) where {T}
    nbits = length(S)
    if i > nbits
        return nothing
    end
    return (S.val & T(2)^(nbits - i)) == 1, i + 1
end
=#

struct BitIterator{T<:Integer}
    val::T
end
Base.length(itr::BitIterator) = sizeof(itr.val) * 8
Base.eltype(itr::BitIterator) = Bool
function Base.iterate(itr::BitIterator{T}, mask = T(1)) where {T}
    iszero(mask) && return nothing
    return !iszero(itr.val & mask), mask << 1
end
Base.length(f::Iterators.Flatten) = sum(length, f.it)

# struct ByteIterator{T}
#     bytes::Vector{T}
# end
# function Base.iterate(S::ByteIterator{T}, i = 1) where {T}
#     if i > 
# end
