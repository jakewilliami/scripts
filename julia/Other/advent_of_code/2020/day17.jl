AbstractIndex{N} = Union{NTuple{N, T}, CartesianIndex{N}} where {T <: Integer}
AbstractIndices{N}  = Union{AbstractArray{I, M}, NTuple{M, I}, CartesianIndices{N, NTuple{N, Base.OneTo{T}}}} where {I <: AbstractIndex{N}, T <: Integer, M}
AbstractIndexOrIndices{N} = Union{AbstractIndex{N}, AbstractIndices{N}}

n_adjacencies(dim::Integer) = 3^dim - 1
n_adjacencies(M::AbstractArray{T, N}) where {T, N} = n_adjacencies(ndims(M))
n_adjacencies(I::AbstractIndexOrIndices{N}) where {N} = n_adjacencies(length(first(I)))

function append_n_times(M::AbstractArray{T, N}, n::Integer, fill_elem::T; dims::Integer = 1) where {T, N}
    sz = ntuple(d -> d == dims ? n : size(M, d), max(N, dims))
    return cat(M, fill(fill_elem, sz); dims = dims)
end

function append_n_times_backwards(M::AbstractArray{T, N}, n::Integer, fill_elem::T; dims::Integer = 1) where {T, N}
    sz = ntuple(d -> d == dims ? n : size(M, d), max(N, dims))
    return cat(fill(fill_elem, sz), M; dims = dims)
end

function promote_to_nD(M::AbstractArray{T, N}, n::Integer, fill_elem::T) where {T, N}
    ndims(M) == n && return M
    n < ndims(M) && throw(error("Cannot reduce the number of dimensions this array has.  See `resize`."))
    
    for d in (ndims(M) + 1):n
        M = append_n_times(M, 1, fill_elem, dims = d)
        M = append_n_times_backwards(M, 1, fill_elem, dims = d)
    end
    
    return M
end
promote_to_3D(M::AbstractArray{T, N}, fill_elem::T) where {T, N} = promote_to_nD(M, 3, fill_elem)

function part1(iterations::Int, layout::Array{Char, N}) where N
    active, inactive = '#', '.'
    origin = ntuple(_ -> 0, N)
    direction_multipliers = (CartesianIndex(i) for i in Iterators.product([-1:1 for _ in 1:N]...) if i != origin)
    
    for _ in 1:iterations
        # expand array
        for i in 1:N
            layout = append_n_times(layout, 1, inactive, dims = i)
            layout = append_n_times_backwards(layout, 1, inactive, dims = i)
        end
        
        layout_clone = copy(layout)
        indices_checked = CartesianIndex{N}[]
        
        for i in CartesianIndices(layout_clone)
            # count number of active, adjacent cells
            n_active = 0
            for j in direction_multipliers
                k = i + j
                a = checkbounds(Bool, layout_clone, k) ? layout_clone[k] : inactive
                if a == active
                    n_active += 1
                else
                    # if the index is out of bounds, be sure to push it so that we know where to expand by
                    i ∈ indices_checked || push!(indices_checked, i)
                end
            end
            
            # update the cube
            cube = layout_clone[i]
            if cube == active
                if n_active ∉ (2, 3) # !(n_active == 2 || n_active == 3)
                    layout[i] = inactive
                end
            elseif cube == inactive
                # If a cube is inactive but exactly 3 of its neighbors are active,
                # the cube becomes active. Otherwise, the cube remains inactive.
                if n_active == 3
                    layout[i] = active
                end
            end
        end
        
        
    end
    
    return layout
end
part1(iterations::Int, layout::Vector{String}) =
    part1(iterations, promote_to_3D(reduce(vcat, permutedims(collect(s)) for s in layout), '.'))
part1(iterations::Int, datafile::String) =
    part1(iterations, readlines(datafile))

@assert count(==('#'), part1(6, "inputs/test.txt")) == 112
@info "Running algorithm on puzzle input"
count(==('#'), part1(6, "inputs/data17.txt"))
