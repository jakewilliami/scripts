#!/usr/bin/env bash
    #=
    exec julia -i --project="$(realpath $(dirname $0))" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#

"""
GRAPHS A FUNCTION'S LEVEL SETS (CONTOURS) (MATH353, Winter, 2020)
"""

using IntervalArithmetic, IntervalRootFinding
# using Plots; plotlyjs()
using Plots; pyplot()


# define the function
V(x,y) = -x^2 - y^2

x = range(-10, stop = 10, length = 50)
y = range(-10, stop = 10, length = 50)

######### RUN ABOVE THIS LINE SEPARATELY TO BELOW

contour(x, y, V, levels = 4)
