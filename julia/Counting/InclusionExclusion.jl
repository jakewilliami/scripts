#!/usr/bin/env bash
    #=
    exec julia --project="~/scripts/julia/Counting/" "${BASH_SOURCE[0]}" "$@" -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#

"""
INCLUSION/EXCLUSION OF SETS: MATH261 (Winter, 2020)
"""

using Combinatorics

A = 
B = 
C = 
D = 

Base.union
