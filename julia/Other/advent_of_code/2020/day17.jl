const datafile = joinpath(@__DIR__, "inputs", "data17.txt")

AbstractIndex{N} = Union{NTuple{N, T}, CartesianIndex{N}} where {T <: Integer}
AbstractIndices{N}  = Union{AbstractArray{I, M}, NTuple{M, I}, CartesianIndices{N, NTuple{N, Base.OneTo{T}}}} where {I <: AbstractIndex{N}, T <: Integer, M}
AbstractIndexOrIndices{N} = Union{AbstractIndex{N}, AbstractIndices{N}}

n_adjacencies(dim::Integer) = 3^dim - 1
n_adjacencies(M::AbstractArray{T, N}) where {T, N} = n_adjacencies(ndims(M))
n_adjacencies(I::AbstractIndexOrIndices{N}) where {N} = n_adjacencies(length(first(I)))

𝟘(n::T) where {T <: Integer} = ntuple(_ -> zero(T), n)

function tryindex(M::AbstractArray{T, N}, idx::AbstractIndex{N}) where {T, N}
    try
        return getindex(M, idx...)
    catch
        return nothing
    end
    
    # should never get here
    return nothing
end
tryindex(M::AbstractArray{T, N}, inds) where {T, N} =
    Union{T, Nothing}[tryindex(M, idx) for idx in inds]

function get_directions(dim::T; include_zero::Bool = false) where T <: Integer
    D = reshape(collect(Iterators.product([-one(T):one(T) for _ in 1:dim]...)), :)
    return include_zero ? D : filter(d -> d ≠ 𝟘(dim), D)
end
get_directions(M::AbstractArray{T, N}; include_zero::Bool = false) where {T, N} = get_directions(ndims(M), include_zero = include_zero)

function _extrema_indices(I::AbstractIndexOrIndices{N}...) where {N}
    return Tuple(extrema(reduce(vcat, permutedims(collect(i)) for i in I...), dims = 1))
end
extrema_indices(I::AbstractIndices{N}) where {N} = _extrema_indices(I)
extrema_indices(i::AbstractIndex{N}...) where {N} = _extrema_indices(i)

function append_n_times(M::AbstractArray{T, N}, n::Integer, fill_elem::T; dims::Integer = 1) where {T, N}
    sz = ntuple(d -> d == dims ? n : size(M, d), max(N, dims))
    return cat(M, fill(fill_elem, sz); dims = dims)
end
append_n_times(M::AbstractArray{T, N}, n::Integer, dims::Integer = 1) where {T <: Number, N} = append_n_times(M, n, zero(T); dims = dims)

function append_n_times_backwards(M::AbstractArray{T, N}, n::Integer, fill_elem::T; dims::Integer = 1) where {T, N}
    sz = ntuple(d -> d == dims ? n : size(M, d), max(N, dims))
    return cat(fill(fill_elem, sz), M; dims = dims)
end
append_n_times_backwards(M::AbstractArray{T, N}, n::Integer, dims::Integer = 1) where {T <: Number, N} = append_n_times(M, n, zero(T); dims = dims)

function promote_to_nD(M::AbstractArray{T, N}, n::Integer, fill_elem::T) where {T, N}
    ndims(M) == n && return M
    n < ndims(M) && throw(error("Cannot reduce the number of dimensions this array has.  See `resize`."))
    
    for d in (ndims(M) + 1):n
        M = append_n_times(M, 1, fill_elem, dims = d)
        M = append_n_times_backwards(M, 1, fill_elem, dims = d)
    end
    
    return M
end
promote_to_nD(M::AbstractArray{T, N}, n::Integer) where {T <: Number, N} = promote_to_nD(M, n, zero(T))

promote_to_3D(M::AbstractArray{T, N}, fill_elem::T) where {T, N} = promote_to_nD(M, 3, fill_elem)
promote_to_3D(M::AbstractArray{T, N}) where {T <: Number, N} = promote_to_3D(M, zero(T))

function _expand_as_required(M::AbstractArray{T, N}, expand_by::T, inds::AbstractIndexOrIndices{N}...) where {T, N}
    indices = Vector{Union{T, Nothing}}()
    ind_extrema = extrema_indices(inds...)
    
    for d in 1:N
        ith_extrema = ind_extrema[d]
        if ! all(map(m -> m ≤ size(M, d), ith_extrema))
            for invalid_idx in filter(i -> i > size(M, i) || i < 1, ith_extrema)
                difference = invalid_idx - size(M, d)
                M = sign(difference) == 1 ? append_n_times(M, abs(difference), expand_by, dims = d) : append_n_times_backwards(M, abs(difference), expand_by, dims = d)
            end
        end
    end
    
    return M
end

expand_as_required(M::AbstractArray{T, N}, expand_by::T, inds::AbstractIndices{N}) where {T, N} = _expand_as_required(M, expand_by, inds)
expand_as_required(M::AbstractArray{T, N}, expand_by::T, inds::AbstractIndex{N}...) where {T, N} = _expand_as_required(M, expand_by, inds)
expand_as_required(M::AbstractArray{T, N}, inds::AbstractIndices{N}) where {T <: Number, N} = _expand_as_required(M, zero(T), inds)
expand_as_required(M::AbstractArray{T, N}, inds::AbstractIndex{N}...) where {T <: Number, N} = _expand_as_required(M, zero(T), inds)

# [println(i) for i in expand_as_required(reduce(vcat, permutedims(collect(i)) for i in readlines("inputs/test.txt")), '.', [(1, 1), (3, 3), (6, 6)])]

# function adjacencies(M::Array{T, N}, expand_by::T, idx::AbstractIndex{N}) where {T, N}
#     idx = Tuple(idx)
#     direction_multipliers = get_directions(M, include_zero = false)
#     adjacent_indices = [idx .+ j for j in direction_multipliers]
#
#     # println(tryindex(M, adjacent_indices))
#     return filter(!isnothing, tryindex(M, adjacent_indices))
#     # return
# end

function adjacencies(M::Array{T, N}, expand_by::T, idx::AbstractIndex{N}) where {T, N}
    idx = Tuple(idx)
    direction_multipliers = get_directions(M, include_zero = false)
    adjacent_indices = AbstractIndex{N}[idx .+ j for j in direction_multipliers]
    M = expand_as_required(M, expand_by, adjacent_indices)
    idx_shift = abs.(size(M) .- idx) # in case we have had to shift the array for non-positive indices
    # for i in adjacent_indices
    #     println("We need to check the direction multiplier $i by shifting it with $(idx_shift .- 1)")
    # end
    return T[M[(i .+ idx_shift .- 1)...] for i in adjacent_indices]
end
adjacencies(M::Array{T, N}, idx::AbstractIndex{N}) where {T <: Number, N} = adjacencies(M, zero(T), idx)

# A = convert.(Int, rand(Int8, 3, 5))
# [println(a) for a in eachrow(A)]
# println("printing adjacencies at index (3, 3)")
# println(adjacencies(A, 0, (3, 3)))

function n_adjacent_to(M::AbstractArray{T, N}, expand_by::T, idx::AbstractIndex{N}, adj_elem::T) where {T, N}
    n = 0
    
    for i in adjacencies(M, expand_by, idx)
        if i == adj_elem
            n += 1
        end
    end
    
    return n
end
n_adjacent_to(M::AbstractArray{T, N}, idx::AbstractIndex{N}, adj_elem::T) where {T <: Number, N} = n_adjacent_to(M, zero(T), idx, adj_elem)

function iterate_slices(A::AbstractArray{T, N}) where {T, N}
    return (A[(Colon() for _ in 1:(N - 1))..., i] for i in 1:N)
end

function part1(layout::Array{Char, N}) where N
    active, inactive = '#', '.'
    layout_clone = copy(layout)
    
    for i in CartesianIndices(layout_clone)
        # println("checking $i")
        n_active = n_adjacent_to(layout_clone, inactive, i, active) # arr, expand_by, idx, adj_elem to count
        cube = layout_clone[i]
        # println("The current position $i has adjacencies $(adjacencies(layout, inactive, i))")
        if cube == active
            # If a cube is active and exactly 2 or 3 of its neighbors are also active,
            # the cube remains active. Otherwise, the cube becomes inactive.
            if !(n_active == 2 || n_active == 3)
                println("found that $i does not have 2 or 3 actives surrounding it; changing to inactive")
                layout[i] = inactive
            end
        elseif cube == inactive
            # If a cube is inactive but exactly 3 of its neighbors are active,
            # the cube becomes active. Otherwise, the cube remains inactive.
            if n_active == 3
                println("found that $i has 3 actives around it; changing it to active because it's a sheep")
                layout[i] = active
            end
        end
    
    end
    
    # # Apparently we need to iterate slice by slice
    # for (s_num, s) in enumerate(iterate_slices(layout))
    #     # iterate through indices in each slice
    #     for i in CartesianIndices(s)
    #         n_active = n_adjacent_to(layout, inactive, i, active)
    #         cube = layout[i]
    #
    #         if cube == active && n_active ∉ [2, 3]
    #             # z_plane[y_idx] = inactive
    #             # println("found that $i does not have 2 or 3 actives surrounding it; changing to inactive")
    #             s[i] = inactive
    #         elseif cube == inactive && n_active == 3
    #             # z_plane[y_idx] = active
    #             # println("found that $i has 4 actives around it; changing it to active because it's a sheep")
    #             s[i] = active
    #         end
    #     end
    #
    #     layout[(Colon() for _ in 1:(N - 1))..., s_num] = s
    # end
    
    
    # assume mapsize is a vector with the desired shape, e.g. mapsize = [2,3,4]

    # N = length(mapsize)
    # Your line to create arrays below, with an extra initial dimension on each array
    # arrays = [ (idx = ones(Int, N+1); idx[n+1] = i;reshape([1:i], tuple(idx...))) for (n,i) in enumerate(mapsize) ]

    # Create indices and fill it one coordinate at a time
    # indices = zeros(Int, tuple(N, mapsize...))
    # for (i,arr) in enumerate(arrays)
    #     dest = sub(indices, i, [Colon() for j=1:N]...)
    #     broadcast!(identity, dest, arr)
    # end
    
    # for z_idx in axes(layout_clone, 1)
    #     z_plane = layout_clone[z_idx, :, :]
    #     original_z_plane = copy(z_plane)
    #
    #     for y_idx in axes(layout_clone, 2)
    #         cube = original_z_plane[y_idx, :]
    #         n_active = n_adjacent_to(layout_clone, inactive, (z_idx, y_idx), active)
    #
    #         if cube == active && n_active ∉ [2, 3]
    #             z_plane[y_idx] = inactive
    #         elseif cube == inactive && n_active == 3
    #             z_plane[y_idx] = active
    #         end
    #     end
    #
    #     layout[z_idx, :] = row
    # end
    return layout
    # return permutedims(layout, [3, 1, 2])
    # return String[join(i) for i in eachrow(layout)]
end
part1(layout::Vector{String}) =
    part1(promote_to_3D(reduce(vcat, permutedims(collect(s)) for s in layout), '.'))
part1(datafile::String) =
    part1(readlines(datafile))

function do_n_times(f::Function, n::Int, A::Vararg{T, N}) where {T, N}
    m = 0
    res = f(A...)

    while m < n
        m += 1
        res = f(res)
    end

    return res
end

# println(do_n_times(sum, 6, [1, 2, 3]))
# do_n_times(part1, 6, readlines("inputs/test.txt"))

part1("inputs/test.txt")
