#! /usr/bin/env julia


##################################################################################
# STEEPEST DESCENT IN ND (MATH353; Winter, 2019)
##################################################################################

# import Pkg; Pkg.add("IntervalArithmetic"), Pkg.add("IntervalRootFinding"), Pkg.add("PlotlyJS"), Pkg.add("ORCA")

# using Plots; plotlyjs()
using SymPy
using LinearAlgebra

@vars x y

f(x) = (x[0] - 3)^2 + (x[1] - 2)^2 # equivalent of python's lambda
df(x) = [2*(x[0] - 3); 2*(x[1] - 2)]
# df(x) = diff(f(x), x)
start = [1 1]'
xstart = [3 2]'

function steepestDescent(x0,eps=1e-5,stepsize=0.1)
    previousStep = 1
    x = x0
    nsteps = 0
    while previousStep>eps
        oldx = x
        x = x - stepsize*df(oldx)
        previousStep = norm(x - oldx)
        nsteps += 1
        # pl.quiver(oldx[0],oldx[1].x[0]-oldx[0],x[1]-oldx[1],scale_units='xy',angles='xy',scale=1)
        # pl.plot([oldx[0],x[0]],[oldx[1],x[1]],'ro')
    end
    println("Local minimum at ", x, " with value ", f(x), " after ", nsteps, " steps")
    return x
end

steepestDescent(start)

# X = np.arange(0, 4, 0.1)
# Y = np.arange(0, 3, 0.1)
# X, Y = np.meshgrid(X, Y)
Z = (X - 2)^4 + (X - 2*Y)^2
# plot3d.plot3d(X,Y,Z)
# fig = pl.figure()
# pl.contour(X, Y, Z, 10)

# ...
