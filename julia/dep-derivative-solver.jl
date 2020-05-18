#! /usr/bin/env julia

#########################################################################################
# EXAMPLE for FINDING DERIVATIVES (MATH244; Autumn, 2020)
# https://docs.sciml.ai/stable/basics/overview/#Overview-of-DifferentialEquations.jl-1
# https://docs.sciml.ai/stable/tutorials/ode_example/#ode_example-1
#########################################################################################

# f(x) = 2 - x^2; c = -0.75
# sec_line(h) = x -> f(c) + (f(c + h) - f(c))/h * (x - c) # by the definition of a derivative
# plot([f, sec_line(1), sec_line(.75), sec_line(.5), sec_line(.25)], -1, 1) # this graph shows f(x)=2−x2 at various secant lines at c=−0.75

# import Pkg; Pkg.add("CalculusWithJulia"); Pkg.add("DifferentialEquations")
using CalculusWithJulia  # load `Plots`, `ImplicitEquations`, `Roots`, `SymPy`
# using DifferentialEquations, Plots


##### With DifferentialEquations

gr()   # better graphics than plotly() here

x = SymFunction("x") # make symbolic functions

f(x) = x^2
#
# # Then we use one of the logical operations–-Lt, Le, Eq, Ge, or Gt–-to construct a predicate to plot.
# r = Eq(f, 2^2)

limit((log(x+h) - log(x))/h, h=>0)


##### With CalculusWithJulia

# f(u,p,t) = 1.01*u
# u0 = 1/2
# tspan = (0.0,1.0)
# prob = ODEProblem(f,u0,tspan)
# sol = solve(prob, Tsit5(), reltol=1e-8, abstol=1e-8)


# plot(sol,linewidth=5,title="Solution to the linear ODE with a thick line",
#      xaxis="Time (t)",yaxis="u(t) (in μm)",label="My Thick Line!") # legend=false
# plot!(sol.t, t->0.5*exp(1.01t),lw=3,ls=:dash,label="True Solution!")
