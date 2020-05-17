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
import math # for pi (math.pi)
import re # for prettifying the input equation


# for myltiple substitutions
class Substitutable(str):
  def __new__(cls, *args, **kwargs):
    newobj = str.__new__(cls, *args, **kwargs)
    newobj.sub = lambda fro,to: Substitutable(re.sub(fro, to, newobj))
    return newobj

# define some substitutions
# yPrime = Substitutable(r"yp = ")
# subTimes = Substitutable(r"*")
# subDivide = Substitutable(r"/")
# subSine = Substitutable(r"sin")
# subCosine = Substitutable(r"cos")
# subTangent = Substitutable(r"tan")


arg = sys.argv[1:]

# an easier trig function
sin = np.sin
cos = np.cos
tan = np.tan

# Create the vectors X and Y
y = np.array(range(100))
yp = np.array(range(100))

# Define the function
# y' == yp[rime] == yp
equation = Substitutable("yp = y*(y-2)") ### <<< INPUT FUNCTION GOES HERE

# evaluate the function
exec(equation)
prettyEqn1 = equation.sub(r"yp = ", "y' = ").sub(r"*", r"\cdot").sub(r"/", r"\textdiv").sub(r"^(.*)$", r"$\1$")
# prettyEqn1 = re.sub(r"yp = ", "y' = ", equation) # make yp -> y'
# prettyEqn2 = re.sub(r"*", r"\cdot", prettyEqn1)
# prettyEqn3 = re.sub(r"/", r"\textdiv", prettyEqn2)
# prettyEqn4 = re.sub(r"^(.*)$", r"$\1$", prettyEqn3) # make math mode

# Create the plot
plt.plot(y,yp,label="y'")

# Add a title
# plt.title(r"$y'=\sin(x)+c$")
plt.title(r"{}".format(prettyEqn1))

# Add X and y Label
plt.xlabel(r"y")
plt.ylabel(r"y'")

# Add a grid
plt.grid(alpha=.4,linestyle='--')

# Add a Legend
plt.legend()

# Show the plot
plt.show()
