#! /usr/bin/env python3


##### FOR MATH244; AUTUMN-WINTER, 2020


from sympy import *
import re # for prettifying the input equation
# import numpy as np # https://stackoverflow.com/q/60383716/12069968


# for multiple substitutions
class Substitutable(str):
  def __new__(cls, *args, **kwargs):
    newobj = str.__new__(cls, *args, **kwargs)
    newobj.sub = lambda fro,to: Substitutable(re.sub(fro, to, newobj))
    return newobj


# sin = np.sin

# get derivatives of functions
x, y = symbols('x y', real=True)

# f = Substitutable("sin(x**2)")
f = x*sin(x)
# d1 = Substitutable(diff(f, x))
# d2 = Substitutable(diff(f, y))


# prettyFunction = f.sub("^yp = ", r"y' = ").sub(r"\*\*\((\d+)\)", r"^{\1}").sub(r"\*\*", r"^").sub(r"\*", r" · ").sub(r"/", r" ÷ ")
# prettyD1 = d1.sub("^yp = ", r"y' = ").sub(r"\*\*\((\d+)\)", r"^{\1}").sub(r"\*\*", r"^").sub(r"\*", r" · ").sub(r"/", r" ÷ ")
# prettyD2 = d2.sub("^yp = ", r"y' = ").sub(r"\*\*\((\d+)\)", r"^{\1}").sub(r"\*\*", r"^").sub(r"\*", r" · ").sub(r"/", r" ÷ ")

print(r"Taking the derivative of {}".format(f), "\n")
dydx = diff(f, x); print("\tWRT x:\t {}".format(dydx))
dxdy = diff(f, y); print("\tWRT y:\t {}".format(dxdy), "\n")
print("\tSecond derivative WRT x:\t {}".format(diff(dydx, x)))
print("\tSecond derivative WRT y:\t {}".format(diff(dxdy, y)))
