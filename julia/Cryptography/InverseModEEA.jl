#!/usr/bin/env bash
    #=
    exec julia --project="~/scripts/julia/Cryptography/" "${BASH_SOURCE[0]}" "$@" -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#

# Parse inputs as integers
a = parse(Int, ARGS[1])
b = parse(Int, ARGS[2])
m = parse(Int, ARGS[2])

# Extended Euclidean Algorithm
# After writing this, I found that Julia Base has a built-in extended Euclidean Algorithm: (g, ainverse, ignore) = gcdx(a, m)
function gcdExtended(a::Integer, b::Integer, x=0, y=0)
	# Base case
	if iszero(a)
		x = 0
		y = 1
		return b, x, y
	else
		b_div_a, b_mod_a = divrem(b, a)
        g, x, y = gcdExtended(b_mod_a, a)
        return g, (y - b_div_a * x), x
	end
end


# Find the modulo multiplicative inverse
function moduloInverse(a::Integer, m::Integer)
	#g, x, y = gcdExtended(a, m) # this method uses my own gcdExtended function (defined above)
    g, x, y = gcdx(a, m) # this method uses Julia's Base gcdExtended function
	if isone(g)
		return mod(x, m)
	else
        error("Modulo inverse of ", a, " modulo ", m, " does not exist")
		return
	end
end


# Printing outputs
output = moduloInverse(a, m)

println("The multiplicative inverse of ", a, " modulo ", m, " is:")
println(output)
