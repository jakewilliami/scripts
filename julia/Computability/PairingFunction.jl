#!/usr/bin/env bash
    #=
    exec julia --project="~/scripts/julia/Computability/" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#


#=
e.g.
	./PairingFunction.jl 9 5 2 0
=#

input = [parse(BigInt, a) for a in ARGS]
    

function pairTuple(x::Integer, y::Integer)::Integer
    if x < 0 || y < 0
        error("We have only defined this function for natural numbers.  See Coding.jl.")
    end
    
    z = BigInt(big(x) + binomial(big(x)+big(y)+1, 2))
    # z = Int(x + (((x+y)*(x+y+1)) / 2)) # also from notes
    # z = Int(((1/2) * (x+y) * (x+y+1)) + y) # from http://en.wikipedia.org/wiki/Pairing_function#Cantor_pairing_function
    #https://docs.julialang.org/en/v1/manual/faq/#...-combines-many-arguments-into-one-argument-in-function-definitions
        
    return z
end

pairTuple(x::Integer, y::Integer, z::Integer...)::Integer = pairTuple(x, pairTuple(y, z...))



paired = pairTuple(input...)
println("\t< ", join(input, ", "), " > ⟼  ", paired)
