#!/usr/bin/env bash
    #=
    exec julia --project="$(realpath $(dirname $0))" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#
	
#=
	f(aa) = ab ⟺ aa*a + b = ab
	f(ba) = bb ⟺ ba*a + b = bb
        ./FindAffineDecryptionKeyFromFormulae.jl aa ab ba bb m
        
    e.g. ./FindAffineDecryptionKeyFromFormulae.jl 0 1 2 3 1 1 26
	
	@show chineseRemainder([3, 1, 6], [5, 7, 8])
=#
	
# using RowEchelon
using LinearAlgebra

aa = Rational(parse(Int, ARGS[1]))
ab = Rational(parse(Int, ARGS[2]))
aeq = Rational(parse(Int, ARGS[3]))
ba = Rational(parse(Int, ARGS[3]))
bb = Rational(parse(Int, ARGS[4]))
beq = Rational(parse(Int, ARGS[5]))
n = parse(Int, ARGS[6])

Rational(parse(Float64, "1"))



function chineseRemainder(a::Array, n::Array)
	#=
	Suppose we have
		x ≡ b1 mod n1
		x ≡ b2 mod n2
		x ≡ b3 mod n3
	So
		Π = n1⋅n2⋅n3 ⟹ Πi = Π ÷ ni
		xi = invmod(x(i-1), n(i-1))
	Note: All the ni and the Π must be coprimes.
	We construct a tableau
		bi			Πi			xi			bi⋅Πi⋅xi
		———————————————————————————————————————————————————————
		b1		Π1 = n2⋅n3		x1			b1⋅Π1⋅x1
		b2		Π2 = n1⋅n3		x2			b2⋅Π2⋅x2
		b3		Π3 = n1⋅n2		x3			b3⋅Π3⋅x3
	Using this,
		x = Σ_{i=1}^{3} bi⋅Πi⋅xi (mod Π)
	=#
	
    Π = prod(n)
    Σ = sum(ai * invmod(Π ÷ ni, ni) * Π ÷ ni for (ni, ai) in zip(n, a))
	x = mod(Σ, Π)
	
	return x, Π # x (mod Π)
end



function solveEqns(n::Integer, A::Array, v::Array) # mod; variables and congruencies
	# v = [3 7; 4 5]
	# e = [2; 7]
	#
	
	# A = rationalize.([2 -1; 4 3])
	# v = rationalize.([1, 2])
	
	w = A\v # solve
	
	ww = [numerator(w[1]) * invmod(denominator(w[1]), n); numerator(w[2]) * invmod(denominator(w[2]), n)]
	
	return mod.(A * ww, n)
	
end


# println(solveEqns(8, [3 7; 4 5], [2; 7]))
println(solveEqns(n, [aa ab; ba bb], [aeq; beq]))


function findDecryptionKey(aa::Integer, ab::Integer, ba::Integer, bb::Integer, m::Integer)
	matrix = [aa 1 ab; ba 1 bb]
	# matrix = rationalize.(rref(matrix))
	
	# for i in matrix
	# 	println(i)
	# end
	aZero = convert(Tuple, findfirst(iszero, matrix))
	
	a = nothing
	b = nothing
	
	if aZero[1] == 1 # check rows
		if aZero[2] == 1 # (1,1); b = (1,3)
			b = matrix[1,3]
		elseif aZero[2] == 2 # (1,2); a = (1,3)
			a = matrix[1,3]
		end
	elseif aZero[1] == 2
		if aZero[2] == 1 # (2,1); b = (2,3)
			b = matrix[2,3]
		elseif aZero[2] == 2 # (2,2); a = (2,3)
			a = matrix[2,3]
		end
	end
	
	
	if ! isnothing(a) && ! isnothing(b)
		return "need to do the tricky case"
	elseif ! isnothing(a)
		return "a is nothing"
	elseif ! isnothing(b)
		return "b is nothing"
	end
	
	
	
	return a, b
	
	
	
		
	# if ! iszero(matrix[1,2]) || ! iszero(matrix[2,1])
	# 	error("Cannot solve.")
	# end
	#
	# a = matrix[1,1]
	# b = matrix[2,2]
	#
	# return convert.(Float64, matrix)
	# return convert(Int, a), b
end


# out = findDecryptionKey(aa, ab, ba, bb, m)

# println("The decryption key is: ", out[1], "(f(x) - ", out[2], ") = x")
# println(out)
