#!/usr/bin/env bash
    #=
    exec julia --project="~/scripts/julia/Computability/" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#
	
#=
e.g.
    ./UnpairingFunction.jl 3 17
=#


## TODO: Make depairing thruple more efficient

n = parse(BigInt, ARGS[1])
a = parse(BigInt, ARGS[2])


pairTuple(x::Integer, y::Integer)::Integer = Int(x + binomial(x+y+1, 2))
pairTuple(x::Integer, y::Integer, z::Integer...)::Integer = pairTuple(x, pairTuple(y, z...))


function unzipTuple(z::Number)
    """
    Inverse of Cantor pairing function
    http://en.wikipedia.org/wiki/Pairing_function#Inverting_the_Cantor_pairing_function
    """
    
    w = floor((sqrt(8 * z + 1) - 1)/2)
    t = (w^2 + w) / 2
    y = Int(z - t)
    x = Int(w - y)
    
    return x, y
end


#=
    We can ``undo'' the pairing:  if m = < x, y >, then we let π0(m) = x and π1(m) = y.  In other words, first undo the pairing and then take the corres-ponding projection function.
    The functions π0 and π1 are also primitive recursive:  they are defined by bounded search, using bounded quantification.  The point is the following,which can be observed by the formula we gave:

    Lemma: ∀ x, y ∈ N, < x, y > ≥ x and < x, y > ≥ y.
    
    So π0(m) is the least z ≤ m such that there is some y ≤ m such that m = < x, y >.   Since  the  pairing  function  is  primitive  recursive,  its  graph (the relation z = < x, y >)  is  also  primitive  recursive.   We  then  use  closure of primitive recursive relations under bounded quantification and boundedsearch.  To sum up,
        π0(m) = (μx ≤ m)(∃y ≤ m)m = < x, y >
    and so π0 (and similarly π1) is primitive recursive.
=#
function findTuple(m::Number)
    x = nothing
    y = nothing
    
    # double loop:
    for x in 0:m, y in 0:m
        if isequal(pairTuple(x, y), m)
            return x,y
        end
    end
end


function findThruple(m::Number)
    x = nothing
    y = nothing
    z = nothing
    
    # comprehension loop:
    # [i*j for i in 0:m, j in 0:m]
    
    # triple loop:
    for x in 0:m, y in 0:m, z in 0:m
        if isequal(pairTuple(x, y, z), m)
            return x, y, z
        end
    end
end



function findQuadruple(m::Number)
    x = nothing
    y = nothing
    z = nothing
        
    for x in 0:m
        for y in 0:m
            for z in 0:m
                for w in 0:m
                    if isequal(pairTuple(x, y, z, w), m)
                        return x, y, z, w
                    end
                end
            end
        end
    end
end
    

# println("For each input, we can depair:")
# for i in ARGS
#     numI = parse(BigInt, i)
#     unpaired = findTuple(numI)
#     println("\t$numI ⟼  < $unpaired >")
# end
# println("\n")
#
# println("For each input, we can de-thruple:")
# for i in ARGS
#     numI = parse(BigInt, i)
#     unpaired = findThruple(numI)
#     println("\t$numI ⟼  < $unpaired >")
# end

out = nothing

if isone(n)
    return a
elseif isequal(n, 2)
    out = findTuple(a)
elseif isequal(n, 3)
    out = findThruple(a)
elseif isequal(n, 4)
    out = findQuadruple(a)
else
    println("This is programme does not currently support extraction of paired quintuples or greater.  This is because the algorithm used to extract these is a searching function, and is very slow for large numbers or large n (e.g., n > 5).")
end

println("\t$a ⟼  < $out >")
