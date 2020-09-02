#!/usr/bin/env bash
    #=
    exec julia --project="~/scripts/julia/Cryptography/" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#
    
a = parse(Int, ARGS[1])
b = parse(Int, ARGS[2])


function hashProbability(k::Integer, r::Integer)::Float64
    r = 2^r
    N = 2^k
    return (1 - exp(-(r^2)/(N))) * 100
end

out = hashProbability(a, b)

println("The probability of choosing a message M1 such that the hash of M1 is the same as the hash of the original M, where $a is the number of binary digits in the message (and so 2^$a is the number of possibilities of M) and $b is the number of places you can modify in the message (and so you can efficiently change 2^$b numbers) is:")
println("\t", out, "%")
