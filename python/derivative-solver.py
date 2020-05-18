#! /usr/bin/env python3


##### FOR MATH244; AUTUMN-WINTER, 2020


from sympy import *
import re # for prettifying the input equation


# for multiple substitutions
class Substitutable(str):
  def __new__(cls, *args, **kwargs):
    newobj = str.__new__(cls, *args, **kwargs)
    newobj.sub = lambda fro,to: Substitutable(re.sub(fro, to, newobj))
    return newobj


# get derivatives of functions

x, y = symbols('x y', real=True)

f = Substitutable("2 + x**2 + (1/4)*y**2")
d1 = Substitutable(diff(f, x))
d2 = Substitutable(diff(f, y))


prettyFunction = f.sub("^yp = ", r"y' = ").sub(r"\*\*\((\d+)\)", r"^{\1}").sub(r"\*\*", r"^").sub(r"\*", r" · ").sub(r"/", r" ÷ ")
prettyD1 = d1.sub("^yp = ", r"y' = ").sub(r"\*\*\((\d+)\)", r"^{\1}").sub(r"\*\*", r"^").sub(r"\*", r" · ").sub(r"/", r" ÷ ")
prettyD2 = d2.sub("^yp = ", r"y' = ").sub(r"\*\*\((\d+)\)", r"^{\1}").sub(r"\*\*", r"^").sub(r"\*", r" · ").sub(r"/", r" ÷ ")

print(r"Taking the derivative of {}".format(prettyFunction), "\n")
print("\tWRT x:\t {}".format(prettyD1))
print("\tWRT y:\t {}".format(prettyD2))
