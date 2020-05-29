#! /usr/bin/env julia


##################################################################################
# EXAMPLE for REDUCING A MATRIX AND FINDING ITS NULL SPACE (MATH251; Winter, 2019)
##################################################################################


using LinearAlgebra
import Pkg; Pkg.add("RowEchelon")
using RowEchelon

A = [-1 4 2 ; -1 3 1 ; -1 2 2]
B = rref(A-I)
C = rref(A-2I)
nullspace(B)
nullspace(C)
