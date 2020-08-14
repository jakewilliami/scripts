#!/usr/bin/env bash
    #=
    exec julia --project="~/scripts/julia/Cryptography/" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#
	
#=
Linear Shift Registers

e.g.
	./LSR. jl "1001" "0100"
=#

constStr = ARGS[1]
initStr = ARGS[2]

function lsrPeriod(constStr::AbstractString, initStr::AbstractString)
	constVec = Vector()
	initVec = Vector()
	sequenceVec = Vector()

	for constChar in split(constStr, "")
		constVec = vcat(constVec, parse(Int, constChar))
	end

	for initChar in split(initStr, "")
		initVec = vcat(initVec, parse(Int, initChar))
	end

	sequenceVec = vcat(sequenceVec, initVec[end:-1:1,end:-1:1])

	for i in 0:20
		global newVal = mod(constVec[4]*sequenceVec[end-3] + constVec[3]*sequenceVec[end-2] + constVec[2]*sequenceVec[end-1] + constVec[1]*sequenceVec[end], 2)
		sequenceVec = vcat(sequenceVec, newVal)
	end

	return join(sequenceVec[1:end]) # previously, sequenceVec[1:end]
end


output = lsrPeriod(constStr, initStr)

println("Sequence from c1c2c3c4 = $constStr, X(0) = $initStr:")
println("\t", output)
