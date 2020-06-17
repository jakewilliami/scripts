#!/usr/bin/env bash
    #=
    exec julia --project="~/scripts/julia/Calculus/" "${BASH_SOURCE[0]}" "$@" -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#

"""
EXAMPLE for GETTING THE INVERSE OF A LAPLACE (MATH244; Winter, 2020)
https://github.com/jlapeyre/Symata.jl/blob/master/src/sympy.jl#L178
"""


using Symata, SymPy

@vars x t
@vars a real=true
@vars s positive=true
@vars n naturals=true

# s, t = Symata.sympy.Symbols('s, t')

expression = 9 / (s^2 + 9)

# https://docs.sympy.org/latest/modules/integrals/integrals.html#sympy.integrals.transforms.inverse_laplace_transform
out = Symata.sympy.InverseLaplaceTransform(expression, s, x, nothing) # 'expression', 's', 'x', and 'plane'

println(out)
