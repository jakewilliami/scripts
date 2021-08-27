# const MATCH_DIMS = Dict{Symbol, Int}(
#     :x => 2,
#     :y => 1,
#     :z => 3,
# )
const MATCH_DIMS = Dict{Int, Symbol}(
    2 => :x,
    1 => :y,
    3 => :z,
)

function check_pointgrid_compliance(point_grid::AbstractArray{T, N}, block_space::BlockSpace{T}) where {T <: Number, N <: Integer}
    
end

"""
```julia
struct PointGrid2D
    x_length::Integer
    z_length::Integer
    point_grid::Matrix{Integer}
end
```

A point grid is a `struct` which importantly contains a parameter ``
"""
struct PointGrid{T}
    point_grid::AbstractArray{Bool, N} where {N <: Integer}
    block_space::BlockSpace{T}
end

# function PointGrid(point_grid::AbstractArray{Bool, N}) where {N <: Integer}
#     block_space = Coordinate[]
#     push!(block_space, ...)
# end
function PointGrid(point_grid::AbstractArray{Bool, N}) where {N <: Integer}
    block_space = Vector{Coordinate}(undef, sum(point_grid))
    for i in 1:M
end
# TODO: should I calculate bounding box in this method, rather than rely on the other method?

"""
A utility function for PointGrid that takes in the dimensions and constructs an empty point grid.
Same definition as `zeros`.  Actually...a wrapper for `zeros`. e.g.,
```julia
julia> PointGrid(Int, 2, 3)
2×3 Matrix{Int64}:
 0  0  0
 0  0  0
```
"""
PointGrid(dims::Int...) = PointGrid(zeros(Bool, dims...))

"""
e.g.,
```julia
julia> PointGrid(Int, (x = 10, y = 62, z = 10));
```
"""
PointGrid(dims::NamedTuple) = PointGrid(T, (dims[MATCH_DIMS[i]] for i in 1:length(dims))...)

# abstract array extensions
Base.size(P::PointGrid2D) = size(P.point_grid)
Base.getindex(P::PointGrid2D, i::Integer) = getindex(P.point_grid, i)
Base.getindex(P::PointGrid2D, I::Vararg{Integer, N}) where {N <: Integer} = getindex(P.point_grid, I)
Base.setindex!(P::PointGrid2D, v, i::Integer) = setindex!(P.point_grid, v, i)
Base.setindex!(P::PointGrid2D, v, I::Vararg{Integer, N}) where {N <: Integer} = setindex!(P.point_grid, v, I)
