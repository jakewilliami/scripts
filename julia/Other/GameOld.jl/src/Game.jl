module Game

using FLoops, Formatting, Combinatorics

export DOWN_DIM, SIDE_DIM
export Board, Vegetable
export solve

DOWN_DIM = 1
SIDE_DIM = 2

struct Board
    M::Matrix{Int}
    x_len::Int
    y_len::Int
    x_vals::Vector{Union{Int, Nothing}}
    y_vals::Vector{Union{Int, Nothing}}
    function Board(M::Matrix{Int}, x_len::Int, y_len::Int, x_vals::Vector{Union{Int, Nothing}}, y_vals::Vector{Union{Int, Nothing}})
        if size(M, 1) != y_len || size(M, 2) != x_len
            error("M does not match size of board")
        end
        return new(M, x_len, y_len, x_vals, y_vals)
    end
end
Board(x_len::Int, y_len::Int, x_vals::Vector{Union{Int, Nothing}}, y_vals::Vector{Union{Int, Nothing}}) = 
    Board(zeros(Int, y_len, x_len), x_len, y_len, x_vals, y_vals)

struct Vegetable
    len::Int
    dim::Int
end
Vegetable(len::Int) = isone(len) ? Vegetable(len, 1) : error("Cannot assume dimension of vegetable")

function solve(B::Board, veges::Dict{Symbol, Vegetable})
    # iterate over all permutations of n elements of the indices
    indices_combinations = Combinatorics.permutations(CartesianIndices(B.M), length(veges))
    @warn "Checking $(format(length(indices_combinations), commas = true)) combinations"
    @floop for p in indices_combinations
        board = copy(B.M)
        # fill in the new arrangement
        isvalid_position = true
        for (i, V) in Iterators.zip(p, veges)
            if !isvalid_position
                break
            end
            _, v = V
            dim = v.dim
            j = i
            for k in 1:v.len
                if j[1] <= size(board, 1) && j[2] <= size(board, 2) && board[j] < 1
                    board[j] += 1
                else
                    isvalid_position = false
                end
                if dim == 1
                    j = CartesianIndex(j[1] + 1, j[2])
                elseif dim == 2
                    j = CartesianIndex(j[1], j[2] + 1)
                else
                    error("Unreachable")
                end
            end
        end

        # check to see if this permutation solves the problem
        solved = true # assume solved and find otherwise
        for dim_num in 1:2 # 2 dimentions because it's a matrix
            solved || continue
            for (i, j) in zip(sum(board, dims = mod1(2 - dim_num + 1, 2)), dim_num == 1 ? B.y_vals : B.x_vals)
                isnothing(j) && continue
                if !(iszero(mod(i, j)) && isone(div(i, j)))
                    solved = false
                    break
                end
            end
        end
        if solved
            return Dict{CartesianIndex, Symbol}(i => first(j) for (i, j) in Iterators.zip(p, veges))
        end
    end
    return nothing
end

#=
veges = Dict{Symbol, Vegetable}(
    :carrot => Vegetable(3, DOWN_DIM), 
    :squash => Vegetable(1), 
    :squash2 => Vegetable(1), 
    :courgette => Vegetable(2, DOWN_DIM), 
    :potato => Vegetable(2, DOWN_DIM), 
    :potato2 => Vegetable(2, SIDE_DIM)
)
res = solve(
    Board(
        6, 6,
        [nothing, 2, 4, 1, 2, 2],
        [nothing, nothing, 3, 4, 2, 2]
    ), veges
)
=#
#=
# display results
for (i, s) in res
    println("$s goes at position $i")
end
=#

end # module
