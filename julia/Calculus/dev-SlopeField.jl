#!/usr/bin/env bash
    #=
    exec julia --project="$(realpath $(dirname $0))" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#

"""
EXAMPLE for FInDING SLOPES FOR A VECTOR FIELD (MATH244; Autumn, 2020)
"""


#=
using CalculusWithJulia, Conda   # loads `SymPy`, `Roots`, `Plots`

@vars x y
u = SymFunction("u")
x0, y0 = 1, 1
F(y,x) = y*x

dsolve(u'(x) - F(u(x), x))

out = dsolve(u'(x) - F(u(x),x), u(x), ics=(u, x0, y0))

p = plot(legend=false)
vectorfieldplot!((x,y) -> [1, F(x,y)], xlims=(0, 2.5), ylims=(0, 10))
plot!(rhs(out),  linewidth=5)
=#

#=
using Makie 
using AbstractPlotting
using AbstractPlotting.MakieLayout

AbstractPlotting.inline!(true)
odeSol(x,y) = Point(-x, 2y) # x'(t) = -x, y'(t) = 2y
scene = Scene(resolution =(400,400))
streamplot!(scene, odeSol, -2..2, -2..2, colormap = :plasma, 
    gridsize= (32,32), arrow_size = 0.07)
save("odeField.png", scene)
=#

# https://lazarusa.github.io/BeautifulMakie/FlowFields/
using CairoMakie
# CairoMakie.activate!()

odeSol(x,y) = Point(-x, 2y) # x'(t) = -x, y'(t) = 2y
fig = Figure(resolution = (1000, 1000), fontsize = 18, font = "times")
ax = Axis(fig, xlabel = "x", ylabel = "y", backgroundcolor = :black)
stplt = streamplot!(ax, odeSol, -2..4, -2..2, colormap = Reverse(:plasma),
gridsize= (32,32), arrow_size = 10)
fig[1, 1] = ax
save("SlopeField.pdf", fig)
