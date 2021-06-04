using SparseArrays

import Base.length

struct Coordinates2D
    x::Integer
    z::Integer
end

const Any2DCoordinates = Union{Coordinates2D, Tuple{Integer, Integer}}

function Coordinates2D(T::Tuple{Integer, Integer})
    return Coordinates2D(T...)
end

#=
struct Coordinates3D
    x::Integer
    y::Integer
    z::Integer
end

function Coordinates3D(T::Tuple{Integer, Integer, Integer})
    x, y, z = T
    return Coordinates3D(x, y, z)
end
=#

"""
```julia
struct PointGrid2D
    bottom_left::Coordinates2D
    top_right::Coordinates2D
    point_grid::SparseMatrixCSC{Int8, Int8}
end
```
"""
struct PointGrid2D
    bottom_left::Coordinates2D
    top_right::Coordinates2D
    point_grid::SparseMatrixCSC{Int8, Int8}
    # check that y2 > y1 etc?
end

#=
struct PointGrid3D
    bottom_left::Coordinates3D
    top_right::Coordinates3D
end

function PointGrid3D(a::Tuple{Integer, Integer, Integer}, b::Tuple{Integer, Integer, Integer})
    return PointGrid3D(Coordinates3D(a), Coordinates3D(b))
end
=#

"""
```julia
PointGrid2D(a::Coordinates2D, b::Coordinates2D)
PointGrid2D(a::Tuple{Integer, Integer}, b::Tuple{Integer, Integer})
PointGrid2D(b::Coordinates2D)
PointGrid2D(b::Tuple{Integer, Integer})
```

`PointGrid2D` will take in a bottom left coordinate and a top right coordinate and produce a grid of empty points.
If only given one coordinate (top right), will assume bottom left is at (0, 0)
"""
function PointGrid2D(a::Coordinates2D, b::Coordinates2D)
    x_length = b.x - a.x
    z_length = b.z - a.x
    empty_point_grid = SparseArrays.spzeros(Int8, z_length, x_length)
    
    return PointGrid2D(a, b, empty_point_grid)
end
PointGrid2D(a::Tuple{Integer, Integer}, b::Tuple{Integer, Integer}) =
    PointGrid2D(Coordinates2D(a), Coordinates2D(b))
PointGrid2D(b::Coordinates2D) = PointGrid2D(Coordinates2D(0, 0), b)
PointGrid2D(b::Tuple{Integer, Integer}) = PointGrid2D(Coordinates2D(0, 0), Coordinates2D(b))

function mutate_pointgrid!(P::PointGrid2D, point::Coordinates2D, value::Int8)
    # need to reverse grid coordinates along the z axis, as matrixes read top left -> bottom right, we read bottom left -> top right
    z = P.top_right.z - point.z + 1
    # reference matrix as (z, x) rather than (x, z), because matrices
    P.point_grid[z, point.x] = value
    # be sure to drop the zero values, as they don't matter
    dropzeros!(P.point_grid)
    return P
end

function mutate_pointgrid!(P::PointGrid2D, point::Tuple{Integer, Integer}, value::Int8)
    mutate_pointgrid!(P::PointGrid2D, Coordinates2D(point), value)
    return P
end

function add_pixel!(P::PointGrid2D, point::Any2DCoordinates)
    mutate_pointgrid!(P, point, Int8(1))
    return P
end

function remove_pixel!(P::PointGrid2D, point::Any2DCoordinates)
    mutate_pointgrid!(P, point, Int8(0))
    return P
end

function add_pixels!(P::PointGrid2D, points::Vector{T}) where {T <: Any2DCoordinates}
    for p in points
        add_pixel!(P, p)
    end
    
    return P
end

function remove_pixels!(P::PointGrid2D, points::Vector{T}) where {T <: Any2DCoordinates}
    for p in points
        remove_pixel!(P, p)
    end
    
    return P
end

function get_bounds(P::PointGrid2D)
    bottom_left = P.bottom_left
    top_right = P.top_right
    bottom_right = Coordinates2D(bottom_left.x, top_right.z)
    top_left = Coordinates2D(top_right.x, bottom_left.z)
    
    return bottom_left, top_right, bottom_right, top_left
end

function length(P::PointGrid2D, side::Symbol)
    if side ∉ [:x, :z]
        error("You must choose either `:x` or `:z` for your side")
    end

    bottom_left = P.bottom_left
    top_right = P.top_right
    side_len = 0

    if side == :x
        side_len = top_right.x - bottom_left.x
    elseif side == :z
        side_len = top_right.z - bottom_left.z
    end

    return side_len
end

function find_center(P::PointGrid2D)
    x_len = length(P, :x)
    z_len = length(P, :z)
    
    return Coordinates2D(x_len / 2, z_len / 2)
end

function rotate(P::PointGrid2D, deg::Number, origin::Coordinates2D)
    new_x = (x - origin.x) * cos(deg * pi / 180)
    new_z = (z - origin.z) * sin(deg * pi / 180)
end

# P = PointGrid2D((0, 0), (3, 3))
P = PointGrid2D((6, 4))
println(P.point_grid)
add_pixels!(P, [(2, 1), (3, 2), (4, 2), (5, 3), (6, 2)])
# println(find_center(P))
