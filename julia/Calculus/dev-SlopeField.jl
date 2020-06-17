#!/usr/bin/env bash
    #=
    exec julia --project="~/scripts/julia/Calculus/" "${BASH_SOURCE[0]}" "$@" -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#

"""
EXAMPLE for FInDING SLOPES FOR A VECTOR FIELD (MATH244; Autumn, 2020)
"""


using CalculusWithJulia, Conda   # loads `SymPy`, `Roots`, `Plots`

@vars x y
u = SymFunction("u")
x0, y0 = 1, 1
F(y,x) = y*x

dsolve(u'(x) - F(u(x), x))

out = dsolve(u'(x) - F(u(x),x), u(x), ics=(u, x0, y0))

p = plot(legend=false)
vectorfieldplot!((x,y) -> [1, F(x,y)], xlims=(0, 2.5), ylims=(0, 10))
plot!(rhs(out),  linewidth=5)
