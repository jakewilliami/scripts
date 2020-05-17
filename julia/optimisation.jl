#! /usr/bin/env julia


# import Pkg; Pkg.add("JuMP"); Pkg.add("GLPK")
using JuMP, GLPK # JuMP provides a domain-specific modelling language for optimisation, where GLPK provides the optimisation solver

#########################################################################
# EXAMPLE for LINEAR PROGRAMMING (MATH353; Autumn, 2020)
# https://nbviewer.jupyter.org/github/JuliaOpt/JuMPTutorials.jl/blob/master/notebook/introduction/getting_started_with_JuMP.ipynb
###########
# min     12x+20y
# s.t.    6x+8y≥100
#         7x+12y≥120
#         x≥0
#         y≥0
#########################################################################


# A model object is a container for variables, constraints, solver options, etc. Models are created with the Model() function. The model can be created with an optimizer attached with default arguments by calling the constructor with the optimizer type, as follows:
model = Model(GLPK.Optimizer)

# A variable is modelled using @variable(name of the model object, variable name and bound, variable type). The bound can be a lower bound, an upper bound or both. If no variable type is defined, then it is treated as real.
@variable(model, a >= 0)
@variable(model, b >= 0)
@variable(model, c >= 0)
@variable(model, d >= 0)
@variable(model, e >= 0)

# A constraint is modelled using @constraint(name of the model object, constraint).
@constraint(model, 2a + 4b + c + 3d + 7e <= 10)
@constraint(model, a + c + d <= 2)
@constraint(model, 4a + 4d + 4e <= 7)

@constraint(model, a in MOI.ZeroOne())  # For integer programming (deprecating integer_programming.jl)
@constraint(model, b in MOI.ZeroOne())
@constraint(model, c in MOI.ZeroOne())
@constraint(model, d in MOI.ZeroOne())
@constraint(model, e in MOI.ZeroOne())
# @constraint(model, x in MOI.Integer())  # For integer programming

# The objective is set in a similar manner using @objective(name of the model object, Min/Max, function to be optimized)
@objective(model, Max, 3a + 6b + 4c + 10d + 3e)

# To solve the optimization problem, we call the optimize function.
optimize!(model)

# Let's now check the value of objective and variables.
@show value(a);
@show value(b);
@show value(c);
@show value(d);
@show value(e);
@show objective_value(model);
