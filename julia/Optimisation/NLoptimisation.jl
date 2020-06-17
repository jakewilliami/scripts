#!/usr/bin/env bash
    #=
    exec julia --project="~/scripts/julia/Optimisation/" "${BASH_SOURCE[0]}" "$@" -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#

"""
EXAMPLE for FINDING NON LINEAR OPTIMISATION (MATH353; Winter, 2020)
"""


using JuMP
using Ipopt

model = Model(Ipopt.Optimizer)

@variable(model, x, start = 0.0)
@variable(model, y, start = 0.0)

@NLobjective(model, Min, 2*x^2 + 2*x*y + y^2 + x - y)

optimize!(model)

println("x = ", value(x), " y = ", value(y))

# adding a (linear) constraint

# @constraint(model, x + y == 10)

optimize!(model)

println("x = ", value(x), " y = ", value(y))
