#!/usr/bin/env bash
    #=
    exec julia --project="$(realpath $(dirname $0))" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#

"""
EXAMPLE for FINDING NON LINEAR OPTIMISATION (MATH353; Winter, 2020)
"""


using JuMP
using Ipopt

model = Model(Ipopt.Optimizer)

@variable(model, x)
@variable(model, y)

@NLobjective(model, Max, x^2 + y^2)

# optimize!(model)

# println("x = ", value(x), " y = ", value(y))

# adding a (linear) constraint

@constraint(model, 0.25*x^2 + y^2 <= 1)
@constraint(model, x^2 + 0.25*y^2 <= 1)
@constraint(model, x >= 0)
@constraint(model, y >= 0)
# @constraint(model, x <= Inf)

optimize!(model)

println("x = ", value(x), " y = ", value(y))
# println("x = ", value(x))
