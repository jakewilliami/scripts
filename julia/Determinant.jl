#! /usr/bin/env julia


# import Pkg; Pkg.add("LinearAlgebra")
using LinearAlgebra

#########################################################################
# EXAMPLE for MATRIX OPERATIONS (MATH353; Winter, 2020)
#########################################################################

M = [2 (2+im) 4; (2-im) 3 im; 4 -im 1]

println("Processing the matrix", M)
println("Determinant: ", det(M))
