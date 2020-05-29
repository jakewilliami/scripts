#! /usr/bin/env python

import pygraphviz as pgv
from pygraphviz import *

G=pgv.AGraph()
G.add_node('a')
G.add_edge('b','c')
G
