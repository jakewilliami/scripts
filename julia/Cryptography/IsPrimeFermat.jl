#!/usr/bin/env bash
    #=
    exec julia --project="~/scripts/julia/Cryptography/" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#
	
#=
	e.g., ./IsPrimeFermat.jl 47
	e.g., ./IsPrimeFermat.jl 3599
	e.g., ./IsPrimeFermat.jl 2599
=#

using Primes

p = parse(BigInt, ARGS[1])

function isPrimeFermatsTheorem(p::Integer)

	if isequal(p, 2)
		return true
	end
	
	for priorPrime in primes(0, Int(ceil(sqrt(p))))
		if ! isone(mod(priorPrime^(p-1), p))
			return false
		end
	end

	return true
end



output = isPrimeFermatsTheorem(p)

if output
	println(p, " is a prime number according to Fermat's Little Theorem.")
elseif ! output
	println(p, " is *not* a prime number according to Fermat's Little Theorem.")
else
	println("Cannot determine whether $p is prime using Fermat's Little Theorem.")
end
