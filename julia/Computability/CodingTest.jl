#!/usr/bin/env bash
    #=
    exec julia --project="$(realpath $(dirname $0))" --color=yes --startup-file=no -e "include(popfirst!(ARGS))" \
    "${BASH_SOURCE[0]}" "$@"
    =#

# Testing

include(joinpath(dirname(@__FILE__), "Coding.jl"))

using Test: @test
using .Coding

function binary_search(a::BigInt, b::BigInt)
    while a != b
        centre = BigInt(round((b + a) / 2))
        println(a, "\n", b, "\n")
        try
            π(centre, algebraic)
            a = centre
        catch
            b = centre
        end
    end
    return a
end

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
    @test π(972292871301644916468488152875266508938968846389326007980307063346008398713128885682044504108288931767348821063618087715644933567266540511345568504718733339523678538338052787779884557674350959673597803113281693069940562881722205193604550737455583875504348606989700013337656597740101535, algebraic) == (7, 44097457325828774284791367377726710860393112311607949541420228252579855118277296197320694764257474575167892495444390648066046785424108252105160)
    # @test π(rand(1:10^1000), algebraic)
    
    @test cℤ([0,-1,1,-2,2,-3,3,-4,4]) == [0, 1, 2, 3, 4, 5, 6, 7, 8]
    @test cℤ((-1,2)) == 16
    @test cℤ((1,1)) == 12
    @test cℤ(3,4) == (6, 8)
    
    @test invcℤ([0, 1, 2, 3, 4, 5, 6, 7, 8]) == [0, -1, 1, -2, 2, -3, 3, -4, 4]
    @test cℤ(invcℤ(79)) == 79
    @test invcℤ(cℤ(-40)) == -40
    @test invcℤ(10029) == -5015
end

@time test()

breaking_point = big(269784546299642447516200362006584287919412051827850717858121896273587851319250)
new_breaking_point = big(444125748226667427697066283969752489153637841873512942978479011859009783869453)
