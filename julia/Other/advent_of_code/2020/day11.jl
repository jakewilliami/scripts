const datafile = joinpath(@__DIR__, "inputs", "data11.txt")

n_adjacencies(dim::Int) = 3^dim - 1

function tryindex(M::Matrix{T}, inds::NTuple{N, Int}...) where {T, N}
    indices = Vector{Union{T, Nothing}}()
    
    for idx in inds
        try
            push!(indices, getindex(M, idx...))
        catch
            push!(indices, nothing)
        end
    end
    
    return indices
end

function adjacencies(M::Matrix{T}, idx::NTuple{N, Int}) where {T, N}
    𝟎 = ntuple(_ -> zero(Int), N)
    return T[k for k in tryindex(M, NTuple{N, Int}[idx .+ j for j in NTuple{N, Int}[t for t in Base.Iterators.product([-one(Int):one(Int) for i in one(Int):N]...)] if j ≠ 𝟎]...) if ! isnothing(k)]
end

function n_adjacent_to(M::Matrix{T}, idx::NTuple{2, Int}, adj_elem::T) where T
    return length(T[i for i in adjacencies(M, idx) if i == adj_elem])
end

function mutate_seats!(seat_layout::Vector{String})
    no_seat, empty_seat, occupied_seat = '.', 'L', '#'
    seat_layout = reduce(vcat, permutedims(collect(s)) for s in seat_layout)
    seat_layout_clone = copy(seat_layout)
    
    for row_idx in axes(seat_layout_clone, 1)
        row = seat_layout_clone[row_idx, :]
        original_row = copy(row)
        
        for seat_idx in axes(seat_layout_clone, 2)
            seat = original_row[seat_idx]
            
            if seat == empty_seat && all(s -> s ≠ occupied_seat, adjacencies(seat_layout_clone, (row_idx, seat_idx)))
                row[seat_idx] = occupied_seat
            elseif seat == occupied_seat && n_adjacent_to(seat_layout_clone, (row_idx, seat_idx), occupied_seat) ≥ 4
                row[seat_idx] = empty_seat
            end
        end
            
        seat_layout[row_idx, :] = row
    end
    
    return String[join(i) for i in eachrow(seat_layout)]
end

function stabilise_chaos(seat_layout::Vector{String}, mutating_funct::Function)
    while true
        old_seat_layout = copy(seat_layout)
        seat_layout = mutating_funct(seat_layout)
            
        if old_seat_layout == seat_layout
            return seat_layout
        end
    end
end

function Base.count(count_by::Char, seat_layout::Vector{String}, mutating_funct::Function)
    return count(==(count_by), reduce(vcat, permutedims(collect(s)) for s in stabilise_chaos(seat_layout, mutating_funct)))
end

println(count('#', readlines(datafile), mutate_seats!))

#=
BenchmarkTools.Trial:
  memory estimate:  1.90 GiB
  allocs estimate:  36545622
  --------------
  minimum time:     5.186 s (3.29% GC)
  median time:      5.186 s (3.29% GC)
  mean time:        5.186 s (3.29% GC)
  maximum time:     5.186 s (3.29% GC)
  --------------
  samples:          1
  evals/sample:     1
=#

function global_adjacencies(M::Matrix{T}, idx::NTuple{N, Int}, adj_elem::T) where {T, N}
    no_seat, empty_seat, occupied_seat = '.', 'L', '#'
    adjacent_indices, 𝟎 = Vector{NTuple{N, Int}}(), ntuple(_ -> zero(Int), N)
    directional_shifts = NTuple{N, Int}[i for i in NTuple{N, Int}[t for t in Base.Iterators.product([-one(Int):one(Int) for i in one(Int):N]...)] if i ≠ 𝟎]
    n_adjacent, adjacent_count = n_adjacencies(ndims(M)), 0

    while adjacent_count < n_adjacent
        for directional_shift in directional_shifts
            while true
                adj_index = idx .+ directional_shift

                if nothing ∈ tryindex(M, adj_index)
                    n_adjacent -= 1
                    break
                end

                if M[adj_index...] ≠ adj_elem
                    adjacent_count += 1
                    push!(adjacent_indices, adj_index)
                    break
                else
                    directional_shift = (abs.(directional_shift) .+ 1) .* sign.(directional_shift)
                end
            end
        end
    end

    return T[M[i...] for i in adjacent_indices]
end

function global_n_adjacent_to(M::Matrix{T}, idx::NTuple{N, Int}, ignored_elem::T, adj_elem::T) where {T, N}
    return length(T[i for i in global_adjacencies(M, idx, ignored_elem) if i == adj_elem])
end

function mutate_seats_again!(seat_layout::Vector{String})
    no_seat, empty_seat, occupied_seat = '.', 'L', '#'
    seat_layout = reduce(vcat, permutedims(collect(s)) for s in seat_layout)
    seat_layout_clone = copy(seat_layout)

    for row_idx in axes(seat_layout_clone, 1)
        row = seat_layout_clone[row_idx, :]
        original_row = copy(row)

        for seat_idx in axes(seat_layout_clone, 2)
            seat = original_row[seat_idx]

            if seat == empty_seat && all(s -> s ≠ occupied_seat, global_adjacencies(seat_layout_clone, (row_idx, seat_idx), no_seat))
                row[seat_idx] = occupied_seat
            elseif seat == occupied_seat && global_n_adjacent_to(seat_layout_clone, (row_idx, seat_idx), no_seat, occupied_seat) ≥ 5
                row[seat_idx] = empty_seat
            end
        end

        seat_layout[row_idx, :] = row
    end

    return String[join(i) for i in eachrow(seat_layout)]
end

println(count('#', readlines(datafile), mutate_seats_again!))

#=
BenchmarkTools.Trial:
  memory estimate:  3.99 GiB
  allocs estimate:  89161036
  --------------
  minimum time:     12.434 s (3.03% GC)
  median time:      12.434 s (3.03% GC)
  mean time:        12.434 s (3.03% GC)
  maximum time:     12.434 s (3.03% GC)
  --------------
  samples:          1
  evals/sample:     1
=#
