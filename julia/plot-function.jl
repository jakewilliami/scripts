#! /usr/bin/env julia

using Pkg
# Pkg.add("Plots")
using Plots

f(x) = log(abs(tan(x)+sec(x))) + sec(x) * tan(x) + (1/(cos(x)))

plot([f], -3, 3) # plot [f(x),...] over [-3, 3]
# or simply
plot([f])
