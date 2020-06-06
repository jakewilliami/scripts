#! /usr/bin/env julia


# https://www.nayuki.io/page/fast-fibonacci-algorithms
# https://gist.github.com/t-nissie/641df996b9035f85b230#gistcomment-2211339

# Returns the tuple (F(n), F(n+1)).
FibSeq(x::Int) = FibSeq(BigInt(x))
input = parse(Int, ARGS[1])

function FibSeq(n::BigInt)
	if n == 0
		return (BigInt(0), BigInt(1))
	else
		a, b = FibSeq(div(n,2))
		c = a * (b * BigInt(2) - a)
		d = a * a + b * b
		if iseven(n)
			return (c, d)
		else
			return (d, c + d)
        end
    end
end

println("Input: n = ", input); println("(F(n),F(n+1)) = ", FibSeq(input))
