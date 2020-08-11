#!/usr/bin/env bash
    #=
    exec julia -i --project="~/scripts/julia/Optimisation/" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#

"""
GRAPHS A FUNCTION IN 3D AND FINDS ITS MINIMA
"""

using IntervalArithmetic, IntervalRootFinding
using Plots; plotlyjs()

# define the function
f(xx) = ( (x, y) = xx; 2*x^2+y^2-2*x*y+2*x^3+x^4 )

# obtain its gradient using the gradient operator ∇ exported by the package
∇f = ∇(f)

# calculate the roots of the gradient using the interval Newton method in the given box:
rts = roots(∇f, (-5..6) × (-5..6), Newton, 1e-5)

midpoints = mid.([root.interval for root in rts]) # <======== ***THIS LINE PRINTS THE ROOTS***

sleep(10)

######### RUN ABOVE THIS LINE SEPARATELY TO BELOW

xs = first.(midpoints)
ys = last.(midpoints)

surface(-5:0.1:6, -6:0.1:6, (x,y)->f([x,y]))
scatter!(xs, ys, f.(midpoints))
