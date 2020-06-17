#! /usr/bin/env python3

import sympy as sp

s, x = sp.symbols('s, x', positive = True)
t = sp.symbols('t')
a = sp.symbols('a', real = True)
n = sp.symbols('n', naturals = True)

exp = sp.exp
pi = sp.pi

expression = 1 / (s**2*(s**2 + 1))

out = sp.inverse_laplace_transform(expression, s, x)

print(out)
