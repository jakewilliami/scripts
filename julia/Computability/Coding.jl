#!/usr/bin/env bash
    #=
    exec julia --project="$(realpath $(dirname $0))" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#
    
module Coding

export PairNTuple, π, alg_π, cℤ, invcℤ

import Base.π # needed in order to redefine it

##############################################################################

# The pairing function:
# Takes integers x1 to x_n so that
# <x1, x2, ..., xn> = <<x_1, ..., xn-1>, x_n>
# And returns their pair.
pairntuple_error = "This function is only defined for natural numbers.  Use cℤ."
PairNTuple(x::Integer, y::Integer)::BigInt = x < 0 || y < 0 ? throw(error("@$airntuple_error")) : BigInt(big(x) + binomial(big(x)+big(y)+1, 2))
PairNTuple(x::Integer, y::Integer, z::Integer...)::BigInt = PairNTuple(PairNTuple(x, y), z...)

##############################################################################

# The brute-force unpairing function:
# Takes in integer m (that is, a natural number)
# and integer n (that is, m ⟼ <x1, ..., xn>)
# returns x1, ..., xn.
# Alternatively, given
@generated function π(::Val{n}, m::Integer) where {n}
    quote
        iszero(n) && return nothing
        isone(n) && return m
        
        @inbounds @fastmath Base.Cartesian.@nloops $n i d -> 0:m begin
            if isequal(PairNTuple((Base.Cartesian.@ntuple $n i)...), m)
                return Base.Cartesian.@ntuple $n i
            end
        end
    end
end
# Ensuring the function is more readible
# (i.e., switch the inputs) such that
# π(m, n) ⟼ <x1, ..., xn> = m
π(m::Integer, n::Integer) = π(Val(n), m)
# default to n=2
π(m::Integer) = π(m, 2)
# Defining a selection function that obtains
# the kth element in the tuple obtained using π;
# e.g., π(83, 2, 0) = 5 = \pi_2^0(83)
# note: by convention this is indexed from zero,
# which is why we need to offset it by one.
π(m::Integer, n::Integer, k::Integer) = π(m, n)[k+1]

# Algebraic unpairing function:
# TODO: Implement flag, e.g.:
# julia> function myfunct(x::Integer)
#        return x^2
#        end
# myfunct (generic function with 1 method)
#
# julia> function myfunct(x::Integer;alt::Bool=true)
#        return x-2
#        end
# myfunct (generic function with 2 method)
#
# julia> myfunct(2)
# 4
#
# julia> myfunct(2;alt=true)
# 0
#
# julia> myfunct(2)
# 4

function alg_π(m::Integer)
    w = floor((sqrt(8*m + 1) - 1) / 2)
    t = (w^2 + w) / 2
    x = m - t
    y = w - x
    
    return Int(x), Int(y)
end

function alg_π(m::Integer, n::Integer; algebra::Bool=true)
    iszero(n) && return nothing
    isone(n) && return m
    
    appended_tuple = alg_π(m)
    
    while n != 2
        appended_tuple = (alg_π(appended_tuple[1])..., appended_tuple[2:end]...)
        n -= 1
    end
    
    return appended_tuple
end

##############################################################################

# coding the cℤ: ℤ ⟶ ℕ
# e.g., with a single input
# z ⟼ cℤ(z)
cℤ(z::Integer)::Integer = z >= 0 ? 2 * z : (2 * abs(z)) - 1
# e.g., with multiple inputs
# z, w, ... ⟼ cℤ(z), cℤ(w), ...
cℤ(z::Integer, w::Integer...) = cℤ(z), cℤ(w...)...
cℤ(zs::AbstractArray{<:Integer}) = cℤ.(zs)
# e.g., with a tuple, ℤ^2 ⟼ ℕ (integer pair to nat)
# (z, w) ⟼ cℤ(<z, w>)
cℤ(r::Tuple{Integer,Integer})::Integer = PairNTuple(cℤ.(r)...)

##############################################################################

# Converts natural numbers to integers
# ℕ ∋ invcℤ(n) ⟼ z ∈ ℤ
invcℤ_error = "Invalid input. We have only defined this function for natural numbers.  Why are you even using it?"
invcℤ(n::Integer) = n < 0 ? throw(error("$invcℤ_error")) : (iseven(n) ? Int(n / 2) : -Int(floor(n / 2) + 1))
invcℤ(ns::AbstractArray{<:Integer}) = invcℤ.(ns)

##############################################################################

end # end module

##############################################################################

# Testing

using Test: @test
using .Coding

function test()
    @test PairNTuple(5,7) == 83
    @test PairNTuple(5,7,20) == 5439
    @test PairNTuple([1,2,3,4,5,6,7,8,9]...) == 131504586847961235687181874578063117114329409897615188504091716162522225834932122128288032336298131
    
    @test π(83, 2) == (5,7)
    @test π(83, 2, 0) == 5
    @test π(83, 3) == (2, 0, 7)
    @test π(1023, 2, 1) == 11
    @test π(big(1315045868479612356871818745780631171143), 1) == 1315045868479612356871818745780631171143
    @test π(5987349857934, 0) == nothing
    @test alg_π(83, 3) == (2, 0, 7)
    @test alg_π(10001, 10) == (0, 0, 0, 0, 0, 0, 1, 3, 4, 9)
    @test alg_π(big(1315045868479612356871818745780631171143), 1) == 1315045868479612356871818745780631171143
    @test alg_π(5987349857934, 0) == nothing
    
    @test cℤ([0,-1,1,-2,2,-3,3,-4,4]) == [0, 1, 2, 3, 4, 5, 6, 7, 8]
    @test cℤ((-1,2)) == 16
    @test cℤ((1,1)) == 12
    @test cℤ(3,4) == (6, 8)
    
    @test invcℤ([0, 1, 2, 3, 4, 5, 6, 7, 8]) == [0, -1, 1, -2, 2, -3, 3, -4, 4]
    @test cℤ(invcℤ(79)) == 79
    @test invcℤ(cℤ(-40)) == -40
    @test invcℤ(10029) == -5015
end

@time test()
