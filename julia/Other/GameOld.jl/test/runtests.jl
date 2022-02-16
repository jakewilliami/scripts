using Game
using Test

@test @testset "Game.jl" begin
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
    expected = Dict{Symbol, CartesianIndex}(
        :courgette => CartesianIndex(4, 6),
        :carrot => CartesianIndex(3, 3),
        :potato => CartesianIndex(3, 5),
        :squash2 => CartesianIndex(3, 2),
        :potato2 => CartesianIndex(6, 2),
        :squash => CartesianIndex(4, 4)
    )
    for (i, s) in res
        @test expected[s] == i
    end
    
    
    
    veges2 = Dict{Symbol, Vegetable}(
        :carrot => Vegetable(3, DOWN_DIM), 
        :squash => Vegetable(1), 
        :squash2 => Vegetable(1), 
        :courgette => Vegetable(2, DOWN_DIM), 
        :potato => Vegetable(2, DOWN_DIM), 
        :potato2 => Vegetable(2, SIDE_DIM),
        :potato3 => Vegetable(2, SIDE_DIM)
    )
    res2 = solve(
        Board(
            6, 6,
            Union{Int, Nothing}[3, nothing, nothing, 3, 2, 5],
            Union{Int, Nothing}[2, 2, 2, 3, 3, 1]
        ), veges
    )
    expected2 = Dict{Symbol, CartesianIndex}(
        :courgette => CartesianIndex(4, 4),
        :carrot => CartesianIndex(4, 6),
        :potato => CartesianIndex(4, 1),
        :squash2 => CartesianIndex(1, 1),
        :potato2 => CartesianIndex(2, 4),
        :squash => CartesianIndex(1, 6),
        :potato3 => CartesianIndex(3, 5),
    )
    for (i, s) in res2
        @test expected2[s] == i
    end
end
