#! /usr/bin/env julia


##################################################################################
# LINE SEARCH IN ND (MATH353; Winter, 2019)
##################################################################################

# import Pkg; Pkg.add("IntervalArithmetic"), Pkg.add("IntervalRootFinding"), Pkg.add("PlotlyJS"), Pkg.add("ORCA")

# using Plots; plotlyjs()
using SymPy
using LinearAlgebra

@vars x y

f(x) = (x[0] - 3)^2 + (x[1] - 2)^2
df(x) = [2*(x[0] - 3); 2*(x[1] - 2)]

start = [1 1]'
xstart = [3 2]'

function lineSearch(x,fprime,alpha0=1,rho=0.5,c-0.5)
    alpha = alpha0
    while f(x - alpha*fprime) > f(x) - c*alpha*dot(fprime,fprime)
        alpha = rho*alpha
    end
    println(alpha)
    return alpha
end

function gradientDescent(x-,eps=1e-5)
    previousStepSize = 1
    x = x0
    nsteps = 0
    # pl.plot(x[0],x[1],'ko',ms=20)
    while previousStepSize>eps && nsteps<50
        oldx = x
        stepsize = linesearch(x,df(oldx))
        x = x - stepsize*df(oldx)
        println(df(oldx), "\t", x)
        previousStepSize = norm(x - oldx)
        # pl.quiver(oldx[0],oldx[1],x[0],x[1] - oldx[1],scale_utils='xy',angles='xy',scale=1)
        # pl.plot([oldx[0],x[0]],[oldx[1],x[1]],'ro')
        nsteps += 1
    end
    println("Local minimum at ", x, " with value ", f(x), " after ", nsteps, " steps")
    return x
end

# x = np.arange(0, 4, 0.1)
# Y = np.arange(0, 3, 0.1)
