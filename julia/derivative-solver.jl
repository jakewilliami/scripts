#! /usr/bin/env julia

#########################################################################################
# EXAMPLE for FINDING DERIVATIVES (MATH244; Autumn, 2020)
# https://docs.sciml.ai/stable/basics/overview/#Overview-of-DifferentialEquations.jl-1
# https://docs.sciml.ai/stable/tutorials/ode_example/#ode_example-1
#########################################################################################

# f(x) = 2 - x^2; c = -0.75
# sec_line(h) = x -> f(c) + (f(c + h) - f(c))/h * (x - c) # by the definition of a derivative
# plot([f, sec_line(1), sec_line(.75), sec_line(.5), sec_line(.25)], -1, 1) # this graph shows f(x)=2−x2 at various secant lines at c=−0.75

# import Pkg; Pkg.add("Calculus")
# Previously tried using packages "CalculusWithJulia" and "DifferentialEquations"
using Calculus

f = "5x^2"

d = differentiate(f, :x)

print(d)
