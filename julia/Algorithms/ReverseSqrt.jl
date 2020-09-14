#!/usr/bin/env bash
    #=
    exec julia --project="$(realpath $(dirname $0))" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#

"""
EXAMPLE for GETTING THE CLOSEST APPROXIMATION OF A SQRT FROM
AN IRRATIONAL FLOATING POINT VALUE (Autumn, 2020)
"""


# using Decimals # to help with floating point arithmetic
# That is, given some integer, find the closest approximation of a square root, and find its remainder

a = parse(Float64, ARGS[1])

function main(a)
	aSquared = a^2
	if isinteger(aSquared)
		return aSquared, 0
	end
	newaSquared = floor(aSquared)
	while true
		newaSquared = floor(newaSquared) - 1
		if isinteger(sqrt(newaSquared))
			remainder = rem(aSquared, floor(newaSquared))
			return Integer(newaSquared), remainder
			break
		end
	end
end

output = main(a)

println(a, " = √", output[1], " with remainder ", output[2])
