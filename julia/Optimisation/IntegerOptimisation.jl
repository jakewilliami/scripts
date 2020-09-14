#!/usr/bin/env bash
    #=
    exec julia --project="$(realpath $(dirname $0))" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#

"""
EXAMPLE for INTEGER PROGRAMMING (MATH353; Autumn, 2020)

https://nbviewer.jupyter.org/github/JuliaOpt/JuMPTutorials.jl/blob/master/notebook/optimization_concepts/integer_programming.ipynb

 a′x≥yb
 c′x≥(1−y)d
 y∈{0,1}
"""


using JuMP, Random, GLPK

Random.seed!(6021);

a = rand(1:100, 5, 5)
c = rand(1:100, 5, 5)
b = rand(1:100, 5)
d = rand(1:100, 5)

model = Model()
@variable(model, x[1:5])
@variable(model, y, Bin)
@constraint(model, a * x .>= y .* b)
@constraint(model, c * x .>= (1 - y) .* d);
