export BoundingBox

"""
```julia
BoundingBox{T <: Number}(mins::Coordinate{T}, maxs::Coordinate{T}, points::Vector{Coordinate{T}})
BoundingBox(mins::Coordinate{T}, maxs::Coordinate{T}) where {T <: Number}
```
A `struct` containing `mins` and `maxs`.  Each `mins` and `maxs` are `Coordinate`s of type `T`.  As `Coordinates` can have many dimensions, the `BoundingBox` could look like one of the following:
```julia
(min_x, min_y), (max_x, max_y)
(min_x, min_y, min_z), (max_x, max_y, max_z)
```
"""
struct BoundingBox{T <: Number}
    mins::Coordinate{T}
    maxs::Coordinate{T}
    points::Vector{Coordinate{T}}
end
function BoundingBox(mins::Coordinate{T}, maxs::Coordinate{T}) where {T <: Number}
    _ndims = ndims(mins)
    #
end
