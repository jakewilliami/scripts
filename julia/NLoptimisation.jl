#! /usr/bin/env julia


#########################################################################
# EXAMPLE for FINDING NON LINEAR OPTIMISATION (MATH353; Winter, 2020)
#########################################################################

using JuMP

import Pkg; Pkg.add("Ipopt")

using Ipopt

model = Model(Ipopt.Optimizer)

@variable(model, x, start = 0.0)
@variable(model, y, start = 0.0)

@NLobjective(model, Min, (1 - x)^2 + 100 * (y - x^2)^2)

optimize!(model)

println("x = ", value(x), " y = ", value(y))

# adding a (linear) constraint

@constraint(model, x + y == 10)

optimize!(model)

println("x = ", value(x), " y = ", value(y))
