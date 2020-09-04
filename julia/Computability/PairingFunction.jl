#!/usr/bin/env bash
    #=
    exec julia --project="~/scripts/julia/Computability/" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#


#=
e.g.
	./PairingFunction.jl 9 5 2 0
=#

# m = parse(Int, ARGS[1])
# a = parse(Int, ARGS[2])
# b = parse(Int, ARGS[3])
# x0 = parse(Int, ARGS[4])

a = parse(BigInt, ARGS[1])

b = nothing
c = nothing

# parse any arguments extra if given
if isequal(length(ARGS), 2)
    b = parse(BigInt, ARGS[2])
end
if isequal(length(ARGS), 3)
    b = parse(BigInt, ARGS[2])
    c = parse(BigInt, ARGS[3])
end
    

function pairTuple(x::Number, y::Number)
    if x < 0 || y < 0
        error("We have only defined this function for natural numbers.  See Coding.jl.")
    end
    
    z = Int(x + binomial(x+y+1, 2))
    # z = Int(x + (((x+y)*(x+y+1)) / 2)) # also from notes
    # z = Int(((1/2) * (x+y) * (x+y+1)) + y) # from http://en.wikipedia.org/wiki/Pairing_function#Cantor_pairing_function
    #https://docs.julialang.org/en/v1/manual/faq/#...-combines-many-arguments-into-one-argument-in-function-definitions
        
    return z
end

pairTuple(x::Number, y::Number, z::Number...) = pairTuple(x, pairTuple(y, z...))
    

# get output
if isequal(length(ARGS), 2)
    paired = pairTuple(a, b)
    println("We pair the input:")
    println("\t< $a, $b > ⟼  $paired\n")
elseif isequal(length(ARGS), 3)
    paired = pairTuple(a, pairTuple(b, c))
    println("We pair the input:")
    println("\t< $a, $b, $c > ⟼  $paired\n")
end
