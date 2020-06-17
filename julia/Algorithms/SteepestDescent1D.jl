#!/usr/bin/env bash
    #=
    exec julia --project="~/scripts/julia/Algorithms/" "${BASH_SOURCE[0]}" "$@" -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#

"""
STEEPEST DESCENT IN 1D (MATH353; Winter, 2019)
"""


# using Plots # ; plotlyjs()
using SymPy

@vars x y

f(x) = 2*x^3 - x^2 - 4*x + 2 # equivalent of python's lambda
df(x) = 6*x^2 - 2*x - 4
startingPoint = 4

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

# pl.figure()
# xstar = steepestDescent(startingPoint)
# X = mp.arange(-2,7,0.1)
# pl.plot(X,f(x))
# pl.plot(xstar,f(xstar),'go',ms=20)
# pl.title('Steepest Descent')
# pl.show()
