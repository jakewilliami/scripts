#!/usr/bin/env bash
    #=
    exec julia -i --project="$(realpath $(dirname $0))" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#

"""
EXAMPLE for FORD-FULKESON ALGORITHM (MATH353; Autumn, 2020)
https://juliagraphs.org/LightGraphsFlows.jl/latest/multiroute.html
"""


using LightGraphsFlows
import LightGraphs
const lg = LightGraphs


# flow_graph = lg.DiGraph(8) # Create a flow graph
#
# flow_edges = [
# (1, 2, 10), (1, 3, 5),  (1, 4, 15), (2, 3, 4),  (2, 5, 9),
# (2, 6, 15), (3, 4, 4),  (3, 6, 8),  (4, 7, 16), (5, 6, 15),
# (5, 8, 10), (6, 7, 15), (6, 8, 10), (7, 3, 6),  (7, 8, 10)
# ]
#
# capacity_matrix = zeros(Int, 8, 8)
#
# for e in flow_edges
#     u, v, f = e
#     add_edge!(flow_graph, u, v)
#     capacity_matrix[u, v] = f
# end



### Need to add manually in the pkg shell with `add https://github.com/dileep-kishore/CombOpt.jl`
# import Pkg; Pkg.add("CombOpt")
# using CombOpt
