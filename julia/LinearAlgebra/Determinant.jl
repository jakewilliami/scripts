#!/usr/bin/env bash
    #=
    exec julia --project="$(realpath $(dirname $0))" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#

"""
EXAMPLE for MATRIX OPERATIONS (MATH353; Winter, 2020)
"""


using LinearAlgebra

M = [2 (2+im) 4; (2-im) 3 im; 4 -im 1]

println("Processing the matrix", M)
println("Determinant: ", det(M))
