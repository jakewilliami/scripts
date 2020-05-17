#! /usr/bin/env julia


# import Pkg; Pkg.add("JuMP"); Pkg.add("Random"); Pkg.add("GLPK")
using JuMP, Random, GLPK

Random.seed!(6021);

#########################################################################
# EXAMPLE for INTEGER PROGRAMMING (MATH353; Autumn, 2020)
# https://nbviewer.jupyter.org/github/JuliaOpt/JuMPTutorials.jl/blob/master/notebook/optimization_concepts/integer_programming.ipynb
###########
# a′x≥yb
# c′x≥(1−y)d
# y∈{0,1}
#########################################################################



a = rand(1:100, 5, 5)
c = rand(1:100, 5, 5)
b = rand(1:100, 5)
d = rand(1:100, 5)

model = Model()
@variable(model, x[1:5])
@variable(model, y, Bin)
@constraint(model, a * x .>= y .* b)
@constraint(model, c * x .>= (1 - y) .* d);
