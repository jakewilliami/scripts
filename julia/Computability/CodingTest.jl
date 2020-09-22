#!/usr/bin/env bash
    #=
    exec julia --project="$(realpath $(dirname $0))" --color=yes --startup-file=no -e "include(popfirst!(ARGS))" \
    "${BASH_SOURCE[0]}" "$@"
    =#

# Testing

include(joinpath(dirname(@__FILE__), "Coding.jl"))

using Test: @test
using .Coding

function test()
    @test PairNTuple(5,7) == 83
    @test PairNTuple(5,7,20) == 5439
    @test PairNTuple([1,2,3,4,5,6,7,8,9]...) == 131504586847961235687181874578063117114329409897615188504091716162522225834932122128288032336298131
    
    @test π(83, 2) == (5,7)
    @test π(83, 2, 0) == 5
    @test π(83, 3) == (2, 0, 7)
    @test π(1023, 2, 1) == 11
    @test π(big(1315045868479612356871818745780631171143), 1) == 1315045868479612356871818745780631171143
    @test π(5987349857934, 0) == nothing
    @test π(83, 3, algebraic) == (2, 0, 7)
    @test π(10001, 10, algebraic) == (0, 0, 0, 0, 0, 0, 1, 3, 4, 9)
    @test π(big(1315045868479612356871818745780631171143), 1, algebraic) == 1315045868479612356871818745780631171143
    @test π(5987349857934, 0, algebraic) == nothing
    small_random = abs(rand(1:100))
    large_random = abs(rand(1:10000))
    @test π(small_random, 3, algebraic) == π(small_random, 3)
    @test π(large_random, 2, algebraic) == π(large_random, 2)
    
    @test cℤ([0,-1,1,-2,2,-3,3,-4,4]) == [0, 1, 2, 3, 4, 5, 6, 7, 8]
    @test cℤ((-1,2)) == 16
    @test cℤ((1,1)) == 12
    @test cℤ(3,4) == (6, 8)
    
    @test invcℤ([0, 1, 2, 3, 4, 5, 6, 7, 8]) == [0, -1, 1, -2, 2, -3, 3, -4, 4]
    @test cℤ(invcℤ(79)) == 79
    @test invcℤ(cℤ(-40)) == -40
    @test invcℤ(10029) == -5015
end

# @time test()

breaking_point = big(269784546299642447516200362006584287919412051827850717858121896273587851319250)

println(π(breaking_point - 1, algebraic))
println(π(breaking_point, algebraic))
