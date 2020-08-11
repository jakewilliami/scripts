#!/usr/bin/env bash
    #=
    exec julia --project="~/scripts/julia/Statistics/" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#

using DataFrames
using CSV
using FreqTables
using Distributions

function main()
	dfRaw = DataFrame!(CSV.File("data.csv"))
	dfPivot = freqtable(dfRaw, :Response, :Condition)

	numberPresent = count(x -> isequal(x,"Present"), dfRaw[!, 1])
	numberAbsent = count(x -> isequal(x,"Absent"), dfRaw[!, 1])

	cdf(d::UnivariateDistribution, x::Real)

	presentRate = dfPivot[:,2] / numberPresent
	absentRate = dfPivot[:,1] / numberAbsent

	return (dprimeYesNo(presentRate[2], absentRate[2]))
end

output = main()

println(output)
