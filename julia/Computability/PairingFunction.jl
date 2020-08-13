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

a = parse(BigInt, ARGS[1])

b = nothing
c = nothing

# parse any arguments extra if given
if isequal(length(ARGS), 2)
    b = parse(BigInt, ARGS[2])
end
if isequal(length(ARGS), 3)
    b = parse(BigInt, ARGS[2])
    c = parse(BigInt, ARGS[3])
end
    

function pairTuple(x::Number, y::Number)
    z = Int(x + binomial(x+y+1, 2))
    # z = Int(x + (((x+y)*(x+y+1)) / 2)) # also from notes
    # z = Int(((1/2) * (x+y) * (x+y+1)) + y) # from http://en.wikipedia.org/wiki/Pairing_function#Cantor_pairing_function
        
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
        
    for x in 0:m
        for y in 0:m
            if isequal(pairTuple(x, y), m)
                return x,y
            end
        end
    end
end


function findThruple(m::Number)
    x = nothing
    y = nothing
    z = nothing
        
    for x in 0:m
        for y in 0:m
            for z in 0:m
                if isequal(pairTuple(x, pairTuple(y, z)), m)
                    return x, y, z
                end
            end
        end
    end
end
    

# get output
if isequal(length(ARGS), 2)
    paired = pairTuple(a, b)
    println("We pair the input:")
    println("\t< $a, $b > ⟼  $paired\n")
elseif isequal(length(ARGS), 3)
    paired = pairTuple(a, pairTuple(b, c))
    println("We pair the input:")
    println("\t< $a, $b, $c > ⟼  $paired\n")
end

# zipped = unzipTuple(a, unzipTuple(b, c))
# zipped = unzipTuple(a, b)
#
println("For each input, we can depair:")
for i in ARGS
    numI = parse(BigInt, i)
    unpaired = findTuple(numI)
    println("\t$numI ⟼  < $unpaired >")
end
println("\n")

println("For each input, we can de-thruple:")
for i in ARGS
    numI = parse(BigInt, i)
    unpaired = findThruple(numI)
    println("\t$numI ⟼  < $unpaired >")
end
