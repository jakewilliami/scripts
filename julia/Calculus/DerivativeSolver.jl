#!/usr/bin/env bash
    #=
    exec julia --project="$(realpath $(dirname $0))" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#

"""
EXAMPLE for FINDING DERIVATIVES (MATH244; Autumn, 2020)
https://docs.sciml.ai/stable/basics/overview/#Overview-of-DifferentialEquations.jl-1
https://docs.sciml.ai/stable/tutorials/ode_example/#ode_example-1
https://mth229.github.io/symbolic.html
"""


using SymPy

@vars x y

f(x,y) = x^2 - 2*x + y^2 - 6*y + 12

d = diff(f(x,y), x)
i = integrate(f(x,y), x)

println("First derivative with respect to x:\t", d)
println("First integral with respect to x:\t", i)
