#!/usr/bin/env bash
    #=
    exec julia --project="~/scripts/julia/Cryptography/" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#


#=
    e.g. PrimitiveRoots.jl 19
=#

p = parse(Int, ARGS[1])

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


function getPrimitiveArray(p::Integer)::Array{AbstractFloat, 2}
    if ! isprime(p)
        error("$p is not a prime number")
    end
    
    if isequal(p, 2)
        return [1]
    end
    
    l = []
    
    # a % b == 0 ⟹ b | a
    for i in 1:p-2
        if iszero(mod(p-1, i))
            l = push!(l, i)
        end
    end
        
    n = length(l)
    arr = zeros(n, n)
        
    for i in 1:n # iterate over rows
        for j in 1:n # iterate over columns
            arr[i,j] = mod(i^j, p)
        end
    end
    
    
    return arr
end


function findPrimitiveRoots(p::Integer, arr::Array{AbstractFloat, 2})::Array{Integer, 1}
    if ! isprime(p)
        error("$p is not a prime number")
    end
    
    if isequal(p, 2)
        return "$p does not have a primitive root."
    end
    
    a = []
    n = size(arr)[1] # or size(arr)[2]
    
    for i in 1:n
        is_primitive = true
        
        for element in arr[i,:]
            
            if isequal(mod(element, p), 1)
                is_primitive = false
                break
            end
        end
        
        if is_primitive
            a = push!(a, i)
        end
    end
    
    return a
end


primitiveArray = getPrimitiveArray(p)
out = findPrimitiveRoots(p, primitiveArray)

displaymatrix(out)
