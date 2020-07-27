#!/usr/bin/env bash
    #=
    exec julia --project="~/scripts/julia/Statistics/" "${BASH_SOURCE[0]}" "$@" -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#

using DataFrames
using DetectionTheory
using CSV
using FreqTables

function main()
	dfRaw = DataFrame!(CSV.File("data.csv"))
	dfPivot = freqtable(dfRaw, :Response, :Condition)

	numberPresent = count(x -> isequal(x,"Present"), dfRaw[!, 1])
	numberAbsent = count(x -> isequal(x,"Absent"), dfRaw[!, 1])

	presentRate = dfPivot[:,2] / numberPresent
	absentRate = dfPivot[:,1] / numberAbsent

	return (dprimeYesNo(presentRate[2], absentRate[2]))
end

output = main()

println(output)
