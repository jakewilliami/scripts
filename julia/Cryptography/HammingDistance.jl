#!/usr/bin/env bash
    #=
    exec julia --project="$(realpath $(dirname $0))" --color=yes --startup-file=no -e "include(popfirst!(ARGS))" \
    "${BASH_SOURCE[0]}" "$@"
    =#

s1 = string(ARGS[1])
s2 = string(ARGS[2])

function main(s1::AbstractString, s2::AbstractString)::Integer
    if ! isequal(length(s1), length(s2))
        throw(error("Cannot compute Hamming Distance on strings of unequal length."))
    end
    
    distance = 0
        
    for i in 1:length(s1)
        if s1[i] != s2[i]
            distance += 1
        end
    end
    
    return distance
end

distance = main(s1, s2)
println("Your input strings have a Hamming Distance of $distance.")
