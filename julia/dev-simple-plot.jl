#! /usr/bin/env julia

# using Pkg
# Pkg.add("Plots")
using CalculusWithJulia
const pl = Plots # this create an an alias, equivalent to Python "import Plots as pl". Declaring it constant may improve the performances.
pl.pyplot()
pl.plot(rand(4,4))
