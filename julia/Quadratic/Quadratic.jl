#!/usr/bin/env bash
    #=
    exec julia --project="$(realpath $(dirname $0))" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#

"""
EXAMPLE for GETTING QUADRATIC ROOTS (MATH244; Autumn, 2020)
"""

using Polynomials


c = parse(Float64, ARGS[1])
b = parse(Float64, ARGS[2])
a = parse(Float64, ARGS[3])


p = Polynomial([a, b, c])

println("\u001b[1;38mRoots for ", p, " exist at:\u001b[0;38m\n")
println("\u001b[1;34m\t", roots(p), "\u001b[0;38m")
