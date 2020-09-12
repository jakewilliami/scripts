#!/usr/bin/env bash
    #=
    exec julia --project="~/scripts/julia/Counting/" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#

"""
FIBONNACI SEQUENCE: MATH261 (Autumn, 2020)
https://www.nayuki.io/page/fast-fibonacci-algorithms
https://gist.github.com/t-nissie/641df996b9035f85b230#gistcomment-2211339
"""


# Returns the tuple (F(n), F(n+1)).
FibSeq(x::Int) = FibSeq(BigInt(x))

input = parse(Int, ARGS[1])
starting_at = 0

function FibSeq(n::BigInt)
	if isequal(n, starting_at)
		return 0, 1
	elseif n > starting_at
		a, b = FibSeq(div(n,2))
		c = a * (b * BigInt(2) - a)
		d = a * a + b * b
		if iseven(n)
			return c, d
		else
			return d, c + d
        end
    else
        throw(error("The Fibonacci sequence is here indexed from n=$starting_at.  Please enter a positive integer for the sequence to work."))
    end
end

println("Input: n = ", input)
println("(F(n),F(n+1)) = ", FibSeq(input))
