#! /usr/bin/env python3


# import numpy as np
# from scipy.integrate import odeint
# import matplotlib.pyplot as plt
#
# def f(s,t):
#     a = 4
#     b = 7
#     n = s[0]
#     c = s[1]
#     dndt = a * n - (c/(c+1)) * b * n
#     dcdt = (c/(c+1)) * n - c + 1
#     return [dndt, dcdt]
#
# t = np.linspace(0,20)
# s0=[20,5]
#
# s = odeint(f,s0,t)
#
# plt.plot(t,s[:,0],'r--', linewidth=2.0)
# plt.plot(t,s[:,1],'b-', linewidth=2.0)
# plt.xlabel("y")
# plt.ylabel("y'")
# plt.legend(["N","C"])
# plt.show()



# Import our modules that we are using
import matplotlib.pyplot as plt
import numpy as np
import sys # for arguments
import re # for prettifying the input equation


# for multiple substitutions
class Substitutable(str):
  def __new__(cls, *args, **kwargs):
    newobj = str.__new__(cls, *args, **kwargs)
    newobj.sub = lambda fro,to: Substitutable(re.sub(fro, to, newobj))
    return newobj


# if arg needed (potentially for future script)
arg = sys.argv[1:]

# an easier trig function
sin = np.sin
cos = np.cos
tan = np.tan
pi = np.pi
exp = np.exp

# Create the vectors X and Y
sample = 100
y = np.array(range(sample))
x = np.array(range(sample))

### IF SINE: uncomment the following two lines, and comment out the exec(equation) line
# y = np.arange(0,4*np.pi,0.1)   # start,stop,step
# yp = sin(y)

# Define the function
# y' == yp[rime] == yp
equation = Substitutable("yp = y*(y-1)*(y-2)") ### <<< INPUT FUNCTION GOES HERE

# evaluate the function
exec(equation)

# make equation pretty for title
prettyEqn = equation.sub("^yp = ", r"y' = ").sub(r"\*\*\((\d+)\)", r"^{\1}").sub(r"\*\*", r"^").sub(r"\*", r"\\cdot ").sub(r"/", r"\\div").sub(r"exp", r"\\exp").sub(r"^(.*)$", r"$\1$")

# Create the plot
plt.plot(y, yp, label="y'")

# Add a title
plt.title(r"{}".format(prettyEqn))

# Add X and y Label
plt.xlabel(r"$y$")
plt.ylabel(r"$y'$")

# set x (and y) limits
axes = plt.gca()
axes.set_xlim([-50,50])
axes.set_ylim([-100,100])

# Add a grid
plt.grid(alpha=.4,linestyle='--')

# Add a Legend
plt.legend()

# Show the plot
plt.show()
