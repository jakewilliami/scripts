#!/usr/bin/env bash
    #=
    exec julia --project="$(realpath $(dirname $0))" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#

using CSV
using DataFrames
# using SimpleANOVA
using ANOVA
using GLM
using Plots

df = DataFrame(CSV.File(joinpath(dirname(@__FILE__), "data.csv"), header = false, delim = "\t"))

names!(df, map(Symbol, ["block", "stim_no", "trial_type", "set_size", "response", "RT"]))

model = fit(LinearModel, @formula(RT ~ set_size), df)
println(anova(model))
