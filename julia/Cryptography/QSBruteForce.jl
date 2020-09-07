#!/usr/bin/env bash
    #=
    exec julia --project="~/scripts/julia/Cryptography/" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#
	
"""
e.g.
	./QSBruteForce.jl 481
"""

n = parse(BigInt, ARGS[1])

function primeFactorisation(n::Integer)
	m = ceil(sqrt(n))

	while ! isinteger(sqrt(mod(m^2, n)))
		m = m + 1
	end
	
	p = Int(m - sqrt(mod(m^2, n)))
	q = Int(m + sqrt(mod(m^2, n)))

	return p, q, Int(ceil(sqrt(n))), Int(mod(ceil(sqrt(n))^2, n)), Int(m), Int(sqrt(mod(m^2, n)))
end


output = primeFactorisation(n)

println("n = ", output[1], "×", output[2], "\n")
println(output[3], "^2 = ", output[4], " mod $n")
println("⋮")
println(output[5], "^2 = ", output[6], "^2 mod $n\t ⟹  \t(", output[5], " − ", output[6], ")⋅(", output[5], " + ", output[6], ")")
# println("\t  ⟹  (", output[5], " − ", output[6], ")⋅(", output[5], " + ", output[6], ")")
