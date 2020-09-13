#!/usr/bin/env bash
    #=
    exec julia --project="~/scripts/julia/Counting/" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#

"""
EXAMPLE for A FACTORIAL FROM A BIG NUMBER (MATH261; Winter, 2020)
With guidance from:
	 - https://math.stackexchange.com/questions/2078997/
	 - https://math.stackexchange.com/questions/3099674/
	 - https://math.stackexchange.com/questions/61755/
"""



using SpecialFunctions, Dates

startTime = Dates.datetime2unix(Dates.now())

"""
    reverseFactorialDavidsMethod(r)
    
Calculates the inverse of a factorial, given r, by
counting up through factorials till it finds a match.
Brute force method.  Found here:
https://codegolf.stackexchange.com/a/205090
"""
function reverseFactorialBruteForce(r)
	if r <= 0
        throw(DomainError((r), "r must be strictly non-negative"))
    end
	
	f(n) = factorial(big(n))
	r!inverse = findfirst(n -> f(n) == r, 1:r)
	
	return r!inverse
end


"""
    reverseFactorialDavidsMethod(r)
    
Calculates the reverse/inverse of a factorial.
Let n! = r (where r stands for "really long number").
Returns approximate n and closest integer n' in a tuple.
David introduced this method to me, and it is very clever.
"""
function reverseFactorialDavidsMethod(r)
	if r <= 0
        throw(DomainError((r), "r must be strictly non-negative"))
    end

	if r == 1
		return 1
	end
	
	count = 1
	s = r
	
	while s > 1
   		count += 1
		s = s / count
	end
   
	if isinteger(s) && isapprox(s, 1)
		return count, Integer(big(r))
	else
		return count - 1, Integer(r - factorial(big(count - 1))), Integer(big(r))
	end
end



"""
	reverseFactorialCountDown(r)

Uses calculateInverseFactorial to get the inverse factorial.  If
that value is not sufficiently close to an integer, counts down
until it finds one that is
"""
function reverseFactorialCountDown(r)
	nsteps = 0
	for i in ceil(BigInt, r - 1):-1:0 # counting from r down to 0 with a step size of -1
		nsteps += 1
		calculateInverseFactorial(i)
		if isapprox(rTuple[1], rTuple[2], atol=1e-3)
			return rTuple[2], Integer(big(r)), nsteps
		end
	end
end



"""
    calculateInverseFactorial(r)
    
Calculates the reverse/inverse of a factorial.
Let n! = r (where r stands for "really long number").
Returns approximate n and closest integer n' in a tuple.
https://math.stackexchange.com/a/2864343/705172
"""
function calculateInverseFactorial(r)
	if r < 1
        throw(DomainError((r), "r must be strictly non-negative"))
    end
	
	m = (log(r)) / (log(log(r) + 1))
	k = (log(SpecialFunctions.gamma(m + 1) / r)) / (log(m + 1)) # https://github.com/JuliaMath/SpecialFunctions.jl/blob/master/src/gamma.jl#L888
	s = m - k + ((log(r / (SpecialFunctions.gamma(m - k + 1)))) / (log(m - k + (1/2))))
	r!inverse = s + ((log(r / (SpecialFunctions.gamma(s + 1)))) / (log(s + (1/2))))
	
	global rTuple = r!inverse, Int(round(r!inverse))
	return rTuple
end



"""
	reverseFactorial(r)
	
Uses calculateInverseFactorial to get the inverse factorial.  If
that value is not sufficiently close to an integer, finds the closest one below it.
"""
function reverseFactorial(r)
	if r == 1
		return 1
	end
	
	calculateInverseFactorial(r)
	
	if isapprox(rTuple[1], rTuple[2], atol=1e-3)
		return rTuple[2], Integer(big(r))
	else
		# reverseFactorialCountDown(r) # previously used this until I realised how slow it is for large integers
		reverseFactorialDavidsMethod(r)
		# calculateInverseFactorial(r)
		
	end
	
end



function main(r)
	out = reverseFactorial(r);
	
	if length(out) == 2
		println(out[1], "! = ", out[2])
	else
		println(out[1], "! + ", out[2], " = ", out[3])
	end
end


# number = 121645100408832000
# number = 402025887398070221045760000
# number = 5550293832739304789551054660550388117999982337982762871343070903773209740507907044212761943998894132603029642967578724274573160149321818341878907651093495984407926316593053871805976798524658790357488383743402086236160000000000000000000000000000000000
main(parse(BigInt, ARGS[1]))

endTime = Dates.datetime2unix(Dates.now())

function getTimeSpan(s=startTime, e=endTime)
	secondSpan = e - s
	minuteSpan = secondSpan / 60
	hourSpan = minuteSpan / 60
	
	if minuteSpan < 1
		return secondSpan, " seconds"
	elseif hourSpan < 1
		return minuteSpan, " minutes"
	else
		return secondSpan, " seconds"
	end
end

times = getTimeSpan()

println("Found the inverse of the factorial in ", times[1], times[2])
