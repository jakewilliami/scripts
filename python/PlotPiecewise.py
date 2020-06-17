#! /usr/bin/env python3

# Import our modules that we are using
import matplotlib.pyplot as plt
import numpy as np
import sys # for arguments
import re # for prettifying the input equation

x= np.linspace(0., 10., 100)

def linear_step_func(x,x0,x1):
    y= np.piecewise(x, [
        x < x0,
       (x >= x0) & (x <= x1),
        x > x1],
            [0.,
            lambda x: x/(x1-x0)+x0/(x0-x1),
             1.]
       )
    return y

plt.plot(x, linear_step_func(x,2, 5))
plt.show()
