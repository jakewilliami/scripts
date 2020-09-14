#!/usr/bin/env bash
    #=
    exec julia --project="$(realpath $(dirname $0))" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#

using DataFrames: DataFrame!
using DetectionTheory: dprimeYesNo
using CSV: File
using FreqTables: freqtable

function main()
	dfRaw = DataFrame!(File("data.csv"))
	dfPivot = freqtable(dfRaw, :Response, :Condition)

	numberPresent = count(x -> isequal(x,"Present"), dfRaw[!, 1])
	numberAbsent = count(x -> isequal(x,"Absent"), dfRaw[!, 1])

	presentRate = dfPivot[:,2] / numberPresent
	absentRate = dfPivot[:,1] / numberAbsent

	return (dprimeYesNo(presentRate[2], absentRate[2]))
end

output = main()

println(output)
