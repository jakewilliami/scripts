#!/usr/bin/env bash
    #=
    exec julia --project="~/scripts/julia/Algorithms/" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#

"""
FINDING THE GREATEST FACTOR OF A NUMBER N (Winter, 2020)
"""

using Primes

input = parse(Int64, ARGS[1])

function main(n)
    original_n = n
    
    if ! isinteger(n)
        return "Please enter an integer."
    end
    
    IS_NEGATIVE = false
    
    if n < 0
        n = n * -1
        IS_NEGATIVE = true
    end
    
    if n == 0
        return 0
    elseif n == 1
        return 1
    elseif Primes.isprime(Integer(n))
        return Integer(n)
    end
    
    n = n - 1
    while ! isinteger(original_n / n)
        n = n - 1
    end
    
    if IS_NEGATIVE
        n = n * -1
    end
    
    return Integer(n)
end
    

println(main(input))
