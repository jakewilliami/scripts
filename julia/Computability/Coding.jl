#!/usr/bin/env bash
    #=
    exec julia --project="$(realpath $(dirname $0))" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#
    
module Coding

export PairNTuple, NatToNTuple,
        IntToNat, IntToNat!, NatToInt, NatToInt!, f

PairNTuple(x::Integer, y::Integer)::Integer = x < 0 || y < 0 ? error("This function is only defined for natural numbers.  Use IntToNat!.") : BigInt(big(x) + binomial(big(x)+big(y)+1, 2))
PairNTuple(x::Integer, y::Integer, z::Integer...)::BigInt = PairNTuple(PairNTuple(x, y), z...) # multiple inputs

@generated function NatToNTuple(::Val{n}, m::Integer) where {n}
    quote
        @inbounds @fastmath Base.Cartesian.@nloops $n i d -> 0:m begin
            if isequal(PairNTuple((Base.Cartesian.@ntuple $n i)...), m)
                return Base.Cartesian.@ntuple $n i
            end
        end
    end
end

NatToNTuple(n::Integer, m::Integer) = NatToNTuple(Val(n), m)

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
    @test PairNTuple(5,7,20) == 5439
    @test PairNTuple([1,2,3,4,5,6,7,8,9]...) == 131504586847961235687181874578063117114329409897615188504091716162522225834932122128288032336298131
    @test NatToNTuple(2, 83) == (5,7)
    @test NatToNTuple(3, 83) == (2, 0, 7)
    
    @test IntToNat!([0,-1,1,-2,2,-3,3,-4,4]) == [0, 1, 2, 3, 4, 5, 6, 7, 8]
    @test IntToNat((-1,2)) == 16
    @test IntToNat((1,1)) == 12
    @test IntToNat(3,4) == (6, 8)
    
    @test NatToInt!([0, 1, 2, 3, 4, 5, 6, 7, 8]) == [0, -1, 1, -2, 2, -3, 3, -4, 4]
    @test IntToNat(NatToInt(79)) == 79
    @test NatToInt(IntToNat(-40)) == -40
end

@time test()
