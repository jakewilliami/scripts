#!/usr/bin/env bash
    #=
    exec julia --project="$(realpath $(dirname $0))" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#

"""
EXAMPLE for PLOTTING FEASIBLE REGION (MATH353; Autumn, 2020)
"""

# suppressMessages(suppressWarnings(Pkg))
using ImplicitEquations, Plots, IntervalConstraintProgramming, ValidatedNumerics, GeometryTypes, Makie

"""
Dependencies for Ubuntu/Debian for Makie include running
 ```
 sudo apt-get install ffmpeg cmake xorg-dev
 ```
For RedHat/Fedora
 ```
 sudo dnf install ffmpeg cmake libXrandr-devel libXinerama-devel libXcursor-devel
 ```
For macOS (as far as I know)
 ```
 brew install ffmpeg cmake
 ```
"""

############### Uses Plots

# f(x) = (2/5)x-6/5
# g(x) = -x
#
# X = -10:10
#
# the_max = max(f(X[end]), g(X[1]))
# the_min = min(f(X[1]), g(X[end]))
#
# plot(X, f, fill = (the_max, 0.5, :auto))
# plot!(X, g, fill = (the_min, 0.5, :auto))

############## Uses ImplicitEquations, Plots (currently code not working)

# f(x) = 2x + 3
# g(x) = x -3x^2
#
# plot(((f < 0) & (g > 0)))

############### Uses IntervalConstraintProgramming, ValidatedNumerics, Plots, GLVisualize

S = @constraint x^2 + y^2 <= 1

# x = y = -100..100   # notation for creating an interval with `ValidatedNumerics.jl`
#
# X = IntervalBox(x, y)
#
# inner, outer = S(X);
#
# inner
# outer

paving = pave(S, X, 0.125);

plot(paving.inner, c="green")
plot!(paving.boundary, c="gray")
