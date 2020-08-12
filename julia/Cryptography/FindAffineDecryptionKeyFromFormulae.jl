#!/usr/bin/env bash
    #=
    exec julia --project="~/scripts/julia/Cryptography/" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#
	
#=
	f(aa) = ab ⟺ aa*a + b = ab
	f(ba) = bb ⟺ ba*a + b = bb
        ./FindAffineDecryptionKeyFromFormulae.jl aa ab ba bb m
        
    e.g. ./FindAffineDecryptionKeyFromFormulae.jl 0 2 3 1 26
=#
	
# using RowEchelon

aa = parse(Int, ARGS[1])
ab = parse(Int, ARGS[2])
ba = parse(Int, ARGS[3])
bb = parse(Int, ARGS[4])
m = parse(Int, ARGS[5])



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


out = findDecryptionKey(aa, ab, ba, bb, m)

# println("The decryption key is: ", out[1], "(f(x) - ", out[2], ") = x")
println(out)
