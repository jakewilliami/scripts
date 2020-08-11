#!/usr/bin/env bash
    #=
    exec julia --project="~/scripts/julia/Cryptography/" "${BASH_SOURCE[0]}" "$@" -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#
	
"""
e.g.
	./LCG.jl 9 5 2 0
"""

m = parse(Int, ARGS[1])
a = parse(Int, ARGS[2])
b = parse(Int, ARGS[3])
x0 = parse(Int, ARGS[4])

function lcgPeriod(m::Integer, a::Integer, b::Integer, x0::Integer)
	sequenceVec = Vector()
	sequenceVec = vcat(sequenceVec, x0)
	global newx = x0

	for i in 0:20
		global newx = mod(a*newx + b, m)
		sequenceVec = vcat(sequenceVec, newx)
	end

	return join(sequenceVec)
end

output = lcgPeriod(m, a, b, x0)

println(output)
