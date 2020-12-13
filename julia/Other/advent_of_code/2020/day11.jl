const datafile = "inputs/data11.txt"

function tryindex(M::Matrix{T}, inds::NTuple{2, Int}...) where T
    indices = Vector{Union{T, Nothing}}()
    
    for idx in inds
        row_idx, col_idx = idx
        try
            push!(indices, getindex(M, row_idx, col_idx))
        catch
            push!(indices, nothing)
        end
    end
    
    return Tuple(indices)
end

function adjacencies(M::Matrix{T}, idx::NTuple{2, Int}) where T
    row_idx, col_idx = idx
    adj_indices = [(row_idx, col_idx - 1), (row_idx - 1, col_idx), (row_idx, col_idx + 1), (row_idx + 1, col_idx), (row_idx - 1, col_idx - 1), (row_idx + 1, col_idx + 1), (row_idx + 1, col_idx - 1), (row_idx - 1, col_idx + 1)]
    
    return T[i for i in tryindex(M, adj_indices...) if ! isnothing(i)]
end

function n_adjacent_to(M::Matrix{T}, idx::NTuple{2, Int}, adj_elem::T) where T
    row_idx, col_idx = idx
    adj_indices = [(row_idx, col_idx - 1), (row_idx - 1, col_idx), (row_idx, col_idx + 1), (row_idx + 1, col_idx), (row_idx - 1, col_idx - 1), (row_idx + 1, col_idx + 1), (row_idx + 1, col_idx - 1), (row_idx - 1, col_idx + 1)]
    
    return length([i for i in adjacencies(M, (row_idx, col_idx)) if i == adj_elem])
end

function mutate_seats!(seat_layout::Vector{String})
    no_seat, empty_seat, occupied_seat = '.', 'L', '#'
    seat_layout = reduce(vcat, (permutedims(collect(s)) for s in seat_layout))
    seat_layout_clone = copy(seat_layout)
    
    for row_idx in 1:size(seat_layout_clone, 1)
        row = seat_layout_clone[row_idx, :]
        original_row = copy(row)
        
        for seat_idx in 1:size(seat_layout_clone, 2)
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

function stabilise_chaos(seat_layout::Vector{String})
    while true
        old_seat_layout = seat_layout
        seat_layout = mutate_seats!(seat_layout)
            
        if old_seat_layout == seat_layout
            return seat_layout
        end
    end
end

function Base.count(count_by::Char, seat_layout::Vector{String})
    return count(==(count_by), reduce(vcat, (permutedims(collect(s)) for s in stabilise_chaos(seat_layout))))
end

println(count('#', readlines(datafile)))
