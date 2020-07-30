#!/usr/bin/env bash
    #=
    exec julia --project="~/scripts/julia/Cryptography/" "${BASH_SOURCE[0]}" "$@" -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#

a = parse(Int, ARGS[1])
b = parse(Int, ARGS[2])
m = parse(Int, ARGS[3])

function findDecryptionKey(a::Integer, b::Integer, m::Integer)
	inva = invmod(a, m)
	return inva, b
end

out = findDecryptionKey(a, b, m)

println("The decryption key is: ", out[1], "(f(x) - ", out[2], ") = x")
