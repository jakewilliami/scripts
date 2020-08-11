#!/usr/bin/env bash
    #=
    exec julia --project="~/scripts/julia/Cryptography/" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#

using Primes

p = parse(Int, ARGS[1])

function isPrimeFermatsTheorem(p::Integer)
	# return isprime(p)

	if isequal(p, 2)
		return true
	end
	
	for priorPrime in primes(0, Int(ceil(sqrt(p))))
		if isone(mod(priorPrime^(p-1), p))
			return true
		else
			isAPrime = false
		end
	end
	
	return false
end


if isPrimeFermatsTheorem(p)
	println(p, " is a prime number according to Fermat's Little Theorem.")
else
	println(p, " is not a prime number according to Fermat's Little Theorem.")
end
