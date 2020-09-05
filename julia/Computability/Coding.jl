#!/usr/bin/env bash
    #=
    exec julia --project="~/scripts/julia/Computability/" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#
    
module Coding

export PairNTuple, NatToPair,
        IntToNat, IntToNat!, NatToInt, NatToInt!, f

PairNTuple(x::Integer, y::Integer)::Integer = x < 0 || y < 0 ? error("This function is only defined for natural numbers.  Use IntToNat!.") : BigInt(big(x) + binomial(big(x)+big(y)+1, 2))
PairNTuple(x::Integer, y::Integer, z::Integer...)::Integer = PairNTuple(x, PairNTuple(y, z...)...) # multiple inputs

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

IntToNat(z::Integer)::Integer = z >= 0 ? 2 * z : (2 * abs(z)) - 1 # base case
IntToNat(z::Integer, w::Integer...) = IntToNat(z), IntToNat(w...)... # multiple inputs
IntToNat(r::Tuple{Integer,Integer})::Integer = PairNTuple(IntToNat!(r)...) # ℤ^2 ⟼ ℕ (integer pair to nat)

IntToNat!(z::Integer, w::Integer...) = error("Instead of IntToNat!(integer1, integer2, ...) please use IntToNat.")
IntToNat!(zs::Tuple{Integer,Integer}) = IntToNat.(zs)
IntToNat!(zs::Vector{<:Integer}) = IntToNat.(zs)

NatToInt(n) = n < 0 ? error("We have only defined this function for natural numbers.  Why are you even using it?") : iseven(n) ? Int(n / 2) : -Int(floor(n / 2) + 1)
NatToInt!(ns) = NatToInt.(ns)

end # end module


## Testing

using Test: @test
using .Coding

function test()
    @test PairNTuple(5,7) == 83
    @test PairNTuple(5,7,20) == 76250
    @test PairNTuple([1,2,3,4,5,6,7,8,9]...) == 6311822920396919125408612435408496798197806713267032880607810866415866365846756729940810210974488939507829451263691704142949582073486360979796574028521007676991056360811439992631142153411030118420604722583844533351520010617917043983043649066080781
    @test NatToPair(83) == (5,7)
    
    @test IntToNat!([0,-1,1,-2,2,-3,3,-4,4]) == [0, 1, 2, 3, 4, 5, 6, 7, 8]
    @test IntToNat((-1,2)) == 16
    @test IntToNat((1,1)) == 12
    @test IntToNat(3,4) == (6, 8)
    
    @test NatToInt!([0, 1, 2, 3, 4, 5, 6, 7, 8]) == [0, -1, 1, -2, 2, -3, 3, -4, 4]
    @test IntToNat(NatToInt(79)) == 79
    @test NatToInt(IntToNat(-40)) == -40
end

@time test()
