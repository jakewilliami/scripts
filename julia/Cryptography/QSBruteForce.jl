#!/usr/bin/env bash
    #=
    exec julia --project="~/scripts/julia/Cryptography/" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#
	
"""
e.g.
	./LCG.jl 9 5 2 0
"""

n = parse(BigInt, ARGS[1])



function primeFactorisation(n::Integer)
	m = ceil(sqrt(n));

	while ! isinteger(sqrt(mod(m^2, n)))
		m = m + 1
	end
	
	p = convert(Int, m-sqrt(mod(m^2, n)))
	q = convert(Int, m+sqrt(mod(m^2, n)))

	return p, q
end


output = primeFactorisation(n)

println("n = ", output[1], "×", output[2])
