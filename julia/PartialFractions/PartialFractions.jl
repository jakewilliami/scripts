#!/usr/bin/env bash
    #=
    exec julia --project="~/scripts/julia/PartialFractions/" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#

"""
Partial Fractions (MATH244 and MATH261; Winter, 2019)
"""


using SymPy

@vars s

f(s) = 1 / ((s - 1)^2 * (s^2 - 2*s + 2))

println(apart(f(s)))
