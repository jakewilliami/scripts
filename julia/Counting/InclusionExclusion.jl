#!/usr/bin/env bash
    #=
    exec julia --project="$(realpath $(dirname $0))" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
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
