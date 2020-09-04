#!/usr/bin/env bash
    #=
    exec julia --project="~/scripts/julia/Computability/" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#

PairNTuple(x::Integer, y::Integer)::Integer = x < 0 || y < 0 ? error("We have only defined this function for natural numbers.  Use IntToNat!.") : Int(x + binomial(x+y+1, 2))
PairNTuple(x::Integer, y::Integer, z::Integer...)::Integer = PairNTuple(x, PairNTuple(y, z...))::Integer

function NatToPair(n::Number)
    a = nothing
    b = nothing
        
    for a in 0:n
        for b in 0:n
            if isequal(PairNTuple(a, b), n)
                return a, b
            end
        end
    end
end

IntToNat(z::Integer)::Integer = z >= 0 ? 2 * z : (2 * abs(z)) - 1
IntToNat!(zs) = IntToNat.(zs)

NatToInt(n) = n < 0 ? error("We have only defined this function for natural numbers.  Why are you even using it?") : iseven(n) ? Int(n / 2) : -Int(floor(n / 2) + 1)
NatToInt!(ns) = NatToInt.(ns)

IntPairToNat(r::Tuple{Integer,Integer})::Integer = PairNTuple(IntToNat!(r)...)











## Testing

function test()
    println(PairNTuple(5,7) == 83)
    println(PairNTuple(5,7,20) == 76250)
    println(NatToPair(83) == (5,7))
    println(IntToNat!([0,-1,1,-2,2,-3,3,-4,4]) == [0, 1, 2, 3, 4, 5, 6, 7, 8])
    println(IntPairToNat((-1,2)) == 16)
    println(IntPairToNat((1,1)) == 12)
    println(NatToInt!([0, 1, 2, 3, 4, 5, 6, 7, 8]) == [0, -1, 1, -2, 2, -3, 3, -4, 4])
    println(IntToNat(NatToInt(79)) == 79)
    println(NatToInt(IntToNat(-40)) == -40)
end

# test()
