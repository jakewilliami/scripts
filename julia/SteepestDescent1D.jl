#! /usr/bin/env julia


##################################################################################
# STEEPEST DESCENT IN 1D (MATH353; Winter, 2019)
##################################################################################

# import Pkg; Pkg.add("IntervalArithmetic"), Pkg.add("IntervalRootFinding"), Pkg.add("PlotlyJS"), Pkg.add("ORCA")

# using Plots; plotlyjs()
using SymPy

@vars x y

f(x) = x^4 - 3*x^3 + 2
df(x) = 4x^3 - 9x^2
startingPoint = 6
# df(x) = diff(f(x), x)

function steepestDescent(x0,eps=1e-5,stepsize=1e-3)
    previousStepSize = 1.0
    x = x0
    nsteps = 1
    while previousStepSize>eps
        oldx = x
        x = x - stepsize*df(oldx)
        previousStepSize = abs(x - oldx)
        # surface(-5:0.1:6, -6:0.1:6, (x,y)->f([x,y]))
        # pl.plot(x,f(x),'ro',ms=5)
        nsteps +=1
        # return nsteps
    end
    println("Local minimum at ", x, " with value ", f(x), " after ", nsteps, " steps.")
    # return x, f(x), nsteps
end

steepestDescent(startingPoint)

# println("Local minimum at ", x, " with value ", f(x), " after ", nsteps, " steps.")

# pl.figure()
# xstar = steepestDescent(6)
# X = mp.arange(-2,7,0.1)
# pl.plot(X,f(x))
# pl.plot(xstar,f(xstar),'go',ms=20)
# pl.title('Steepest Descent')
# pl.show()
