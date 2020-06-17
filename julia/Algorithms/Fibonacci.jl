#!/usr/bin/env bash
    #=
    exec julia --project="~/scripts/julia/Algorithms/" "${BASH_SOURCE[0]}" "$@" -e 'include(popfirst!(ARGS))' \
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
startingAt = 0

function FibSeq(n::BigInt)
	if n == startingAt
		return (BigInt(0), BigInt(1))
	elseif n > startingAt
		a, b = FibSeq(div(n,2))
		c = a * (b * BigInt(2) - a)
		d = a * a + b * b
		if iseven(n)
			return (c, d)
		else
			return (d, c + d)
        end
    else
        error("The Fibonacci sequence is here indexed from n=1.  Please enter a positive integer for the sequence to work.") && return
    end
end

    println("Input: n = ", input)
    println("(F(n),F(n+1)) = ", FibSeq(input))
