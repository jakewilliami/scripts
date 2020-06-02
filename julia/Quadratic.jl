#! /usr/bin/env julia


#########################################################################
# EXAMPLE for GETTING QUADRATIC ROOTS (MATH244; Autumn, 2020)
#########################################################################


##############################################################################
################################# My Method ##################################
##############################################################################
# http://wiener.math.csi.cuny.edu/~verzani/tmp/julia/zeroes.html


# import Pkg; Pkg.add("Gadfly"); Pkg.add("Compose")
# using Gadfly, Compose
#
# a = parse(Float64, ARGS[1])
# b = parse(Float64, ARGS[2])
# c = parse(Float64, ARGS[3])
#
# discr = b^2 - 4*a*c
#
# function quadratic(a, b, c)
#     if discr >= 0
#         global x1 = (-b + sqrt(discr))/(2a)
#         global x2 = (-b - sqrt(discr))/(2a)
#     else
#         error("Only complex roots") && return
#     end
#     return x1, x2
# end
#
# quadratic(a, b, c)
#
# println("\n\n\u001b[1;38mYou input the polynomial:\u001b[0;38m\n")
# println("\t\u001b[0;3;38my = ", a, "x^2 + ", b, "x + ", c,  "\u001b[0;38m\n")
# println("\u001b[1;38mThe roots for this polynomial are solvable at \u001b[0;38m\u001b[0;3;38m( x + ", -x1, " ) ( x + ", -x2, " ) = 0 \u001b[0;38m\u001b[1;38m to give\u001b[0;38m\n")
# println("\u001b[1;34m\tx1 = ", x1, "\u001b[0;38m")
# println("\u001b[1;34m\tx2 = ", x2, "\u001b[0;38m")


##############################################################################
########################## JuliaMaths' Method ################################
##############################################################################

# import Pkg; Pkg.add("Polynomials")
using Polynomials


c = parse(Float64, ARGS[1])
b = parse(Float64, ARGS[2])
a = parse(Float64, ARGS[3])


p = Polynomial([a, b, c])

println("\u001b[1;38mRoots for ", p, " exist at:\u001b[0;38m\n")
println("\u001b[1;34m\t", roots(p), "\u001b[0;38m")
