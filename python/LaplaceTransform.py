#! /usr/bin/env python3

import sympy as sp
import math

s, x = sp.symbols('s, x', positive = True)
t = sp.symbols('t')
a = sp.symbols('a', real = True)
n = sp.symbols('n', naturals = True)

exp = sp.exp
cos = sp.cos
sin = sp.sin
sqrt = sp.sqrt

expression = cos(x)*sin(x)

out = sp.laplace_transform(expression, x, s)

print(out)
