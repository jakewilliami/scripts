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
        
        # As we need to change all cubes simultaneously, we
        # must make a copy and use as reference
        layout_clone = copy(layout)
        
        for i in CartesianIndices(layout_clone)
            # count number of active, adjacent cells
            n_active = 0
            for j in direction_multipliers
                k = i + j
                a = checkbounds(Bool, layout_clone, k) ? layout_clone[k] : inactive
                if a == active
                    n_active += 1
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

#=
julia> @benchmark part1(6, "inputs/data17.txt")
BenchmarkTools.Trial:
  memory estimate:  133.00 MiB
  allocs estimate:  2609189
  --------------
  minimum time:     273.586 ms (3.14% GC)
  median time:      281.505 ms (3.33% GC)
  mean time:        283.308 ms (3.50% GC)
  maximum time:     311.833 ms (3.56% GC)
  --------------
  samples:          18
  evals/sample:     1
=#
