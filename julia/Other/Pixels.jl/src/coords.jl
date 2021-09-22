export AbstractCoordinate, Coordinate

abstract type AbstractCoordinate end

"""
```julia
Coordinate{T <: Number}(value::Tuple{T})
```
A `struct` containing one field, `value`, which is of type `Tuple`.  The size of this tuple is the dimensionality of the `Coordinate`; e.g., `Coordinate((1, 2, 3))` exists in 3 dimensions.
"""
struct Coordinate{T <: Number} <: AbstractCoordinate
    value::NTuple{N, T} where {N}
end
"Simpler construction of `Coordinate`s with variable arguments."
Coordinate(t::T...) where {T <: Number} = Coordinate{T}(t)
Base.eltype(C::Coordinate) = eltype(C.value)
Base.ndims(C::Coordinate) = length(C.value)
