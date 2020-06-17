#! /usr/bin/env python3


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
sample = 10000
y = np.arange(sample)
x = np.arange(sample)

### IF SINE: uncomment the following two lines, and comment out the exec(equation) line
# y = np.arange(0,4*np.pi,0.1)   # start,stop,step
# yp = sin(y)

# Define the function
# y' == yp[rime] == yp
equation = Substitutable("yp = y*(y-1)*(y-2)") ### <<<======= INPUT FUNCTION GOES HERE

# evaluate the function
exec(equation)

# make equation pretty for title
prettyEqn = equation.sub("^yp = ", r"y' = ").sub(r"\*\*\((\d+)\)", r"^{\1}").sub(r"\*\*", r"^").sub(r"\*", r"\\cdot ").sub(r"/", r"\\div").sub(r"exp", r"\\exp").sub(r"^(.*)$", r"$\1$")

# setting the axes at the centre
fig = plt.figure()

# Create the plot
plt.plot(y, yp, 'g', label="y'")

# Add a title
plt.title(r"{}".format(prettyEqn))

# # Add X and y Label
plt.xlabel(r"$y$")
plt.ylabel(r"$y'$")

# Add a grid
plt.grid(alpha=.4,linestyle='--')

# Show the plot
plt.show()
