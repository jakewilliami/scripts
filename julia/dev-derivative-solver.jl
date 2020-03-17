#! /usr/bin/env julia

# f(x) = 2 - x^2; c = -0.75
# sec_line(h) = x -> f(c) + (f(c + h) - f(c))/h * (x - c) # by the definition of a derivative
# plot([f, sec_line(1), sec_line(.75), sec_line(.5), sec_line(.25)], -1, 1) # this graph shows f(x)=2−x2 at various secant lines at c=−0.75

# import Pkg; Pkg.add("CalculusWithJulia")
using CalculusWithJulia  # load `Plots`, `ImplicitEquations`, `Roots`, `SymPy`
gr()   # better graphics than plotly() here

f(x,y) = x^2 + y^5

# Then we use one of the logical operations–-Lt, Le, Eq, Ge, or Gt–-to construct a predicate to plot.
r = Eq(f, 2^2)
