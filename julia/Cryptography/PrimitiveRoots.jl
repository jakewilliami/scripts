#!/usr/bin/env bash
    #=
    exec julia --project="$(realpath $(dirname $0))" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#


#=
    e.g. PrimitiveRoots.jl 19
    
    The idea is that you are given some prime p.  For p, you look through all a between 1 and p-1.  You also need to find the "proper" divisors of p-1 (that is, those numbers from 1 to p-1 which divide p-1 but are not p-1).  From these you can make a table, whose y axis is the numbers of $a$, and whose x axis is the proper divisors n.  To fill in the rows of the table, you must compute a_i^{n_i}.  You look through this table row-wise; the primitive roots are the numbers a whose rows do not have a one in them.
=#

using Primes: isprime

p = parse(BigInt, ARGS[1])

#=
p: prime
a: 1, 2, ..., p-1
a is a primitive root mod p if a^1, a^2, ..., a^{p-1} ≢ 1 mod p

The: a is a primitive root if a^n ≢ 1 mod p ∀ n with
    i) n | p-1; and
    ii) n ≠ p-1
=#


function displaymatrix(M::AbstractArray)
    #=
    A function to show a big matrix on one console screen (similar to default `print` of numpy arrays in Python).
    
    parameter `M`: Some array [type: Abstract Array]
    
    return: A nice array to print [type: plain text
    =#
    return show(IOContext(stdout, :limit => true, :compact => true, :short => true), "text/plain", M)
end


function getPrimitiveArray(p::Integer)
    if ! isprime(p)
        throw(error("$p is not a prime number"))
    end
    
    if isequal(p, 2)
        return [1]
    end
    
    l = []
    
    # a % b == 0 ⟹ b | a
    for n in 1:p-2
       if iszero(mod(p-1, n))
           l = push!(l, n)
       end
    end
        
    L = length(l)
    arr = Array{Float64}(undef, p-1, L)
        
    for i in 1:p-1 # iterate over rows
        for j in 1:L # iterate over columns
            arr[i,j] = mod(i^l[j], p)
        end
    end
    
    
    return arr, l # primitiveArray, properDivisors
end


function findPrimitiveRoots(p::Integer)::Array{Integer, 1}
    if isequal(p, 2)
        return "$p does not have a primitive root."
    end
    
    primitiveArray, properDivisors = getPrimitiveArray(p)
    
    a = []
    h, w = size(primitiveArray)
    
    if w != length(properDivisors)
        throw(error("An error occurred.  I don't know how it occurred."))
    end
    
    for i in 1:h
        is_primitive = true # innocent till proven guilty
        
        for j in 1:w
            if isone(mod(primitiveArray[i,j], p))
                is_primitive = false
                break
            end
        end
        
        if is_primitive
            a = push!(a, primitiveArray[i, 1])
        end
    end
    
    return a
end



out = findPrimitiveRoots(p)

displaymatrix(out)
# println(getPrimitiveArray(p))
# displaymatrix(getPrimitiveArray(p)[1])
# displaymatrix(getPrimitiveArray(p)[2])
