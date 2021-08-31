"""
```julia
BlockSpace{T <: Number}(points::Vector{Coordinate{T}}, BoundingBox{T})
BlockSpace(points::Vector{Coordinate{T}}) where {T <: Number}
```
A `struct` containing a `Vector` of points—that is, a set of points in the space, whose type are `Coordinate`s—and a `BoundingBox`.  The bounding box will be calculated if none is given.
"""
struct BlockSpace{T <: Number}
    points::Vector{Coordinate{T}}
    bounding_box::BoundingBox{T}
end
Base.ndims(S::BlockSpace) = ndims(S.points[1]) # the dimensionality of the BlockSpace is the dimentionality of any one of its coordinates
function BlockSpace(points::Vector{Coordinate{T}}) where {T <: Number}
    _reference_coord = points[1]
    _ndims = ndims(_reference_coord)
    _coord_type = eltype(_reference_coord)
    minmaxs = Vector{NTuple{2, _coord_type}}(undef, _ndims) # (min_n, max_n)
    for i in 1:_ndims
        min_n = _reference_coord.value[i]
        max_n = min_n
        for p in points[2:end]
            n = p.value[i]
            if n < min_n
                min_n = n
            end
            if n > max_n
                max_n = n
            end
        end
        minmaxs[i] = (min_n, max_n)
    end
    mins = Coordinate((first(t) for t in minmaxs)...)
    maxs = Coordinate((last(t) for t in minmaxs)...)
    return BlockSpace(points, BoundingBox{_coord_type}(mins, maxs))
end
