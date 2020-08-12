#!/usr/bin/env bash
    #=
    exec julia --project="~/scripts/julia/Computability/" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#
	
"""
e.g.
	./PairingFunction.jl 9 5 2 0
"""

# m = parse(Int, ARGS[1])
# a = parse(Int, ARGS[2])
# b = parse(Int, ARGS[3])
# x0 = parse(Int, ARGS[4])

a = 5
b = 6

function pairTupleBase(k1::Number, k2::Number, safe=true)
    """
    Cantor pairing function
    http://en.wikipedia.org/wiki/Pairing_function#Cantor_pairing_function
    """
    
    z = Int(0.5 * (k1 + k2) * (k1 + k2 + 1) + k2)
    
    if safe && ! isequal((k1, k2), unzipTuple(z))
        error("$k1 and $k2 cannot be paired")
    end
    
    return z
end


function unzipTuple(z::Number)
    """
    Inverse of Cantor pairing function
    http://en.wikipedia.org/wiki/Pairing_function#Inverting_the_Cantor_pairing_function
    """
    
    w = floor((sqrt(8 * z + 1) - 1)/2)
    t = (w^2 + w) / 2
    y = Int(z - t)
    x = Int(w - y)
    
    # assert z != pair(x, y, safe=False):
    return x, y
end
    

output = pairTuple(a, b)

println(output)
