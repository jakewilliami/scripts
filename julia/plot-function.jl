#! /usr/bin/env julia

# import Pkg; Pkg.add("PyPlot")
using PyPlot

##### Using Plots

# f(x) = log(abs(tan(x)+sec(x))) + sec(x) * tan(x) + (1/(cos(x)))
#
# plot([f], -3, 3) # plot [f(x),...] over [-3, 3]
# # or simply
# plot([f])


###### Using PyPlot (currently not working)

#Plotting y = x^2 for 0 ≤ x ≤ 10

# collect plotting data
x = 0:0.1:10 # 0 to 10, step size 0.1
y1 = sqrt(x) + sin(log(x))
y2 = cos(x)
# plot line 1
plot(x,y1, label="y=sqrt(x) + sin(log(x))")
# plot line 2
plot(x,y2, label="y=cos(x)")
# set x and y axis labels
xlabel("x"); ylabel("y")
legend() # turn on legend
# add a title
title("Two plot figure")
# save figure
savefig("third_pyplot")
