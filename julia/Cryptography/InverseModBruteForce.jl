#!/usr/bin/env bash
    #=
    exec julia --project="~/scripts/julia/Cryptography/" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#

a = parse(Int, ARGS[1])
n = parse(Int, ARGS[2])

function main(a, n, c=0)
	while true
		c = c + 1
		modulo_value = mod(a * c, n)
		if isone(modulo_value)
			return c
			break
		end
	end
end

output = main(a, n)

println("The multiplicative inverse of ", a, " modulo ", n, " is:")
println(output)
