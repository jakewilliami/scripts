#! /usr/bin/env python3


from sympy import *

# get derivatives of functions

x = symbols('x')

f = sin(x)
d = diff(f)

print(d)
