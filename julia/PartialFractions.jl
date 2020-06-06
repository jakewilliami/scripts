#! /usr/bin/env julia


##################################################################################
# Partial Fractions (MATH244 and MATH261; Winter, 2019)
##################################################################################

using SymPy
#using CalculusWithJulia

@vars s

f(s) = 1 / ((s - 1)^2 * (s^2 - 2*s + 2))

println(apart(f(s)))
