#! /usr/bin/env julia


##################################################################################
# SYMBOLIC LAPLACE TRANSFORMATION CALCULATIONS (MATH244; Winter, 2019)
##################################################################################

using SymPy

@vars x
@vars a real=true
@vars s positive=true
@vars n naturals=true

# f(x) = parse(Sym, ARGS[1])

# input = @eval(Meta.parse(ARGS[1]))
# f(x) = convert(input, Sym)
f(x) = (x)/(s)
#
# println(typeof(f(x)))

function laplaceTransform()
    laplace = simplify(integrate(f(x)*exp(-s*x), (x, 0, Inf)))
    println(laplace)
end

laplaceTransform()
