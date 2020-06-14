#! /usr/bin/env julia

#########################################################################################
# EXAMPLE for FINDING HESSIAN MATRICES (MATH244; Autumn, 2020)
#########################################################################################



# import Pkg; Pkg.add("ForwardDiff")
using ForwardDiff, SymPy, LinearAlgebra

f(x) = 2*x[2]^2+x[1]^2 # f must take a vector as input

g = x -> ForwardDiff.gradient(f, x); # g is now a function representing the gradient of f

g([1,2]) # evaluate the partial derivatives (gradient) at some point x



@vars x y

f(x,y) =  2*x^2+y^2-2*x*y+2*x^3+x^4

fx = diff(f(x,y), x)
fxx = diff(fx, x)
fy = diff(f(x,y), y)
fyy = diff(fy, y)
fxy = diff(fx, y)
fyx = diff(fy, x)

H = [fxx fxy;fyx fyy]

println("First derivative with respect to x (fx):\t", fx)
println("Second derivative with respect to x (fxx):\t", fxx)
println("First derivative with respect to y (fy):\t", fy)
println("Second derivative with respect to y (fyy):\t", fyy)
println("fxy:\t\t\t\t\t\t", fxy)
println("fyx:\t\t\t\t\t\t", fyx, "\n")

println("Hence, we have a Hessian Matrix:")
println(H, "\n")

println("The determinant of the Hessian Matrix is:\t", det(H), ", and")
println("fxx + fyy is:\t\t\t\t\t", simplify(fxx+fyy))
