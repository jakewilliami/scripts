#!/usr/bin/env bash
    #=
    exec julia --project="~/scripts/julia/Algorithms/" "${BASH_SOURCE[0]}" "$@" -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#

"""
EXAMPLE for GETTING THE CLOSEST APPROXIMATION OF A SQRT FROM
AN IRRATIONAL FLOATING POINT VALUE (Autumn, 2020)
"""


# using Decimals # to help with floating point arithmetic
