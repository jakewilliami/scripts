#! /usr/bin/env julia


##################################################################################
# LINE SEARCH IN ND (MATH353; Winter, 2019)
##################################################################################

# import Pkg; Pkg.add("IntervalArithmetic"), Pkg.add("IntervalRootFinding"), Pkg.add("PlotlyJS"), Pkg.add("ORCA")

# using Plots; plotlyjs()
using SymPy
using LinearAlgebra

@vars x y

f(x) = (x[1] - 3)^2 + (x[2] - 2)^2
df(x) = [2*(x[1] - 3); 2*(x[2] - 2)] # indexing arrays begin at 1 in Julia

start = [1; 1]
xstart = [3; 2]

function lineSearch(x,fprime,alpha0=1,rho=0.5,c=0.5)
    nChanges = 0
    alpha = alpha0
    while f(x - alpha*fprime) > f(x) - c*alpha*dot(fprime,fprime)
        alpha = rho*alpha
        nChanges += 1
    end
    if nChanges == 1
        println("Starting alpha = ", alpha)
    else
        println("New alpha = ", alpha)
    end
    return alpha
end

function gradientDescent(x0,eps=1e-5)
    previousStepSize = 1
    x = x0
    nSteps = 0
    # pl.plot(x[0],x[1],'ko',ms=20)
    while previousStepSize > eps && nSteps < 50
        oldx = x
        stepsize = lineSearch(x,df(oldx))
        x = x - stepsize*df(oldx)
        println("Old x: ", df(oldx), "\tNew x:", x, "\n")
        previousStepSize = norm(x - oldx)
        # pl.quiver(oldx[0],oldx[1],x[0],x[1] - oldx[1],scale_utils='xy',angles='xy',scale=1)
        # pl.plot([oldx[0],x[0]],[oldx[1],x[1]],'ro')
        nSteps += 1
    end
    println("\nLocal minimum at ", x, " with value ", f(x), " after ", nSteps, " steps")
    return x
end

# x = np.arange(0, 4, 0.1)
# Y = np.arange(0, 3, 0.1)
# X, Y = np.meshgrid(X, Y)
# Z = (X-2)^4 + (X-2.0*Y)^2
# Z = (X-3)^2 + (Y-2)^2

# pl.figure()
# pl.contour(X,Y,Z,10)

# pl.plot(start[0],start[1],'ko',ms=20)
x = gradientDescent(start)
# pl.plot(xstar[0],xstar[1],'go',ms=20)
# pl.title("Line Search")
# pl.show()

println(x)
