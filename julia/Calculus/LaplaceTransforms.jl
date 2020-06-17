#!/usr/bin/env bash
    #=
    exec julia --project="~/scripts/julia/Calculus/" "${BASH_SOURCE[0]}" "$@" -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#

"""
SYMBOLIC LAPLACE TRANSFORMATION CALCULATIONS (MATH244; Winter, 2019)
"""


using SymPy

@vars s x positive = true
@vars t
@vars a real = true
@vars n naturals = true


# f(x) = parse(Sym, ARGS[1])

# input = @eval(Meta.parse(ARGS[1]))
# f(x) = convert(input, Sym)
expression = exp(3*x)*exp(4*x)
#
# println(typeof(f(x)))

function laplaceTransform()
    raw_laplace = integrate(expression*exp(-s*x), (x, 0, Inf))
    laplace = simplify(raw_laplace)
    return(laplace)
end

println(laplaceTransform())
