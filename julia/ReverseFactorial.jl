#! /usr/bin/env julia

#########################################################################
# EXAMPLE for A FACTORIAL FROM A BIG NUMBER (MATH261; Winter, 2020)
#########################################################################

# guidance from:
	# https://math.stackexchange.com/questions/2078997/
	# https://math.stackexchange.com/questions/3099674/
	# https://math.stackexchange.com/questions/61755/
	# https://math.stackexchange.com/questions/1624347/ <=== mainly this one!

# import Pkg; Pkg.add("SpecialFunctions")

using SpecialFunctions # for gamma function?
using Match

# Convert decimal to binary numbers
# From https://gist.github.com/CliffordAnderson/6a3439c91f293d053ce334bdcee17c31
function toBinary(num)
	@match num begin
		0 => "0"
		1 => "1"
		_ => string(tobin(div(num,2)), mod(num, 2))
	end
end

function convertStringToInteger(string)
	y = parse(Float64, string)
	x = isinteger(y) ? Int(y) : y
end


"""
    reverseFactorial(r)
    
Calculates the reverse/inverse of a factorial.
Let n! = r (where r stands for "really long number").
Returns approximate n and closest integer n' in a tuple.
"""
function reverseFactorial(r)
    if r < 0
        throw(DomainError((r), "r must be strictly non-negative"))
    end
	
	# log without specified base will be natural log
	m = (log(r)) / (log(log(r) + 1))
	k = (log(factorial(m) / r)) / (log(m + 1))
	s = m - k + ((log(r / (factorial(m - k)))) / (log(m - k + (1/2))))
	# \exclamdown ===> ¡
	r¥ = s + ((log(r / (factorial(s)))) / (log(s + (1/2))))
	return r¥, Int(round(r¥))
	
end


"""
	reverseFactorialAlt(r)
	
Brute force approach.  Returns n.
"""
function reverseFactorialAlt(r)
	# not mine: https://codegolf.stackexchange.com/a/205090
	if r < 0
        throw(DomainError((r), "r must be strictly non-negative"))
    end
	
	f(n) = factorial(big(n))
	s = findfirst(n->f(n) == r, 1:r)
	return s
end


# number = 121645100408832000
number = parse(Float64, ARGS[1])
# number = 402025887398070221045760000

println(reverseFactorial(number))
