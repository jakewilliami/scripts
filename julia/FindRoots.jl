#! /usr/bin/env julia

# import Pkg; Pkg.add("IntervalArithmetic"), Pkg.add("IntervalRootFinding"), Pkg.add("PlotlyJS"), Pkg.add("ORCA")

using IntervalArithmetic, IntervalRootFinding

# define the function
f(xx) = ( (x, y) = xx; x^2 - 2*x + y^2 - 6*y + 12 )

# obtain its gradient using the gradient operator ∇ exported by the package
∇f = ∇(f)

# calculate the roots of the gradient using the interval Newton method in the given box:
rts = roots(∇f, (-5..6) × (-5..6), Newton, 1e-5)

midpoints = mid.([root.interval for root in rts]) # <======== THIS LINE PRINTS THE ROOTS

######### RUN ABOVE THIS LINE SEPARATELY TO BELOW

xs = first.(midpoints)
ys = last.(midpoints)

using Plots; plotlyjs()

surface(-5:0.1:6, -6:0.1:6, (x,y)->f([x,y]))
scatter!(xs, ys, f.(midpoints))
