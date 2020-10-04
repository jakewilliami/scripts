#!/usr/bin/env bash
    #=
    exec julia --project="$(realpath $(dirname $0))" --color=yes --startup-file=no -e "include(popfirst!(ARGS))" \
    "${BASH_SOURCE[0]}" "$@"
    =#
	
module ModuloFields

using Polynomials
using Mods
using LinearAlgebra

export Polynomial, coeffs
export displaymatrix
export mod
export list_polys, multiplication_table, list_span, islinear

function displaymatrix(M::AbstractArray)
    return show(IOContext(stdout, :limit => true, :compact => true, :short => true), "text/plain", M); print("\n")
end

Base.mod(p::Polynomial, n::Integer) = Polynomial(mod.(p.coeffs, n))

@generated function list_polys(::Val{n}, m::Integer)::AbstractArray where {n}
    quote
		polys = Polynomial[]
		
        Base.Cartesian.@nloops $n i d -> 0:m-1 begin
			push!(polys, Polynomial([(Base.Cartesian.@ntuple $n i)...]))
        end
		
		return polys
    end
end

list_polys(n::Integer, modulo::Integer)::AbstractArray = list_polys(Val(n), modulo)

function multiplication_table(degree::Integer, modulo::Integer)::Matrix
	polys = list_polys(degree, modulo)
	number_of_polys = length(polys)
	poly_matrix = Matrix{Polynomial}(undef, number_of_polys, number_of_polys)
	
	for i in 1:number_of_polys, j in 1:number_of_polys
		poly_matrix[i,j] = mod(polys[i]*polys[j], modulo)
	end

	return poly_matrix
end

function list_span(u̲::Vector, v̲::Vector, modulo::Integer)::Vector
	span = Vector[]
	
	for λ in 0:modulo-1, γ in 0:modulo-1
		w̲ = mod.(λ*u̲ + γ*v̲, modulo)
		if w̲ ∉ span
			push!(span, w̲)
		end
	end
	
	return span
end

function list_span(u̲::Vector, v̲::Vector, t̲::Vector, modulo::Integer)::Vector
	span = Vector[]
	
	for λ in 0:modulo-1, γ in 0:modulo-1, α in 0:modulo-1
		w̲ = mod.(λ*u̲ + γ*v̲ + α*t̲, modulo)
		if w̲ ∉ span
			push!(span, w̲)
		end
	end
	
	return span
end

@inline function _allequal_length_(A::Array)::Bool
    length(A) < 2 && return true
	
    e1 = A[1]
	
    @inbounds for i in 2:length(A)
        isequal(length(A[i]), length(e1)) || return false
    end
	
    return true
end

function islinear(C::Vector, modulo::Integer)#::Bool
	_allequal_length_(C) || return false # not all codes are of the same length
	block_length = length(C[1])
	𝟎 = fill(0, block_length)
		
	𝟎 ∈ C || return false # the zero vector is not in the code
	
	for c̲ ∈ C
		for λ in 0:modulo-1
			mod.(λ*c̲, modulo) ∈ C || return false # this code isn't closed under scalar multiplication
		end
		
		for c̲ ∈ C, c̲′ ∈ C
			if c̲ ≠ c̲′
				mod.(c̲ + c̲′, modulo) ∈ C || return false # this code isn't closed under addition
			end
		end
	end
	
	return true
end

end # end module

include("Distance.jl")

using .Distance
using .ModuloFields
using Test: @test
using BenchmarkTools: @btime

function test()
	p = Polynomial([1, 1, 2, 0, 1, 2, 1])
	q = Polynomial([2, 1, 1])
	a = Polynomial([0, 1, 0, 1, 0, 0, 1])
	b = Polynomial([1, 0, 1])

	@test mod(rem(p, q), 3) == Polynomial([1, 1])
	@test mod(rem(a, b), 2) == Polynomial([1])
	
	@test multiplication_table(2, 3) == Polynomial[Polynomial([0]) Polynomial([0]) Polynomial([0]) Polynomial([0]) Polynomial([0]) Polynomial([0]) Polynomial([0]) Polynomial([0]) Polynomial([0]); Polynomial([0]) Polynomial([1]) Polynomial([2]) Polynomial([0, 1]) Polynomial([1, 1]) Polynomial([2, 1]) Polynomial([0, 2]) Polynomial([1, 2]) Polynomial([2, 2]); Polynomial([0]) Polynomial([2]) Polynomial([1]) Polynomial([0, 2]) Polynomial([2, 2]) Polynomial([1, 2]) Polynomial([0, 1]) Polynomial([2, 1]) Polynomial([1, 1]); Polynomial([0]) Polynomial([0, 1]) Polynomial([0, 2]) Polynomial([0, 0, 1]) Polynomial([0, 1, 1]) Polynomial([0, 2, 1]) Polynomial([0, 0, 2]) Polynomial([0, 1, 2]) Polynomial([0, 2, 2]); Polynomial([0]) Polynomial([1, 1]) Polynomial([2, 2]) Polynomial([0, 1, 1]) Polynomial([1, 2, 1]) Polynomial([2, 0, 1]) Polynomial([0, 2, 2]) Polynomial([1, 0, 2]) Polynomial([2, 1, 2]); Polynomial([0]) Polynomial([2, 1]) Polynomial([1, 2]) Polynomial([0, 2, 1]) Polynomial([2, 0, 1]) Polynomial([1, 1, 1]) Polynomial([0, 1, 2]) Polynomial([2, 2, 2]) Polynomial([1, 0, 2]); Polynomial([0]) Polynomial([0, 2]) Polynomial([0, 1]) Polynomial([0, 0, 2]) Polynomial([0, 2, 2]) Polynomial([0, 1, 2]) Polynomial([0, 0, 1]) Polynomial([0, 2, 1]) Polynomial([0, 1, 1]); Polynomial([0]) Polynomial([1, 2]) Polynomial([2, 1]) Polynomial([0, 1, 2]) Polynomial([1, 0, 2]) Polynomial([2, 2, 2]) Polynomial([0, 2, 1]) Polynomial([1, 1, 1]) Polynomial([2, 0, 1]); Polynomial([0]) Polynomial([2, 2]) Polynomial([1, 1]) Polynomial([0, 2, 2]) Polynomial([2, 1, 2]) Polynomial([1, 0, 2]) Polynomial([0, 1, 1]) Polynomial([2, 0, 1]) Polynomial([1, 2, 1])]
	
	@test list_span([2, 1, 1], [1, 1, 1], 3) == [[0, 0, 0], [1, 1, 1], [2, 2, 2], [2, 1, 1], [0, 2, 2], [1, 0, 0], [1, 2, 2], [2, 0, 0], [0, 1, 1]]
	
	@test islinear([[0,0,0],[1,1,1],[1,0,1],[1,1,0]], 2) == false
	@test islinear([[0,0,0],[1,1,1],[1,0,1],[0,1,0]], 2) == true
	
	@test code_distance([[0,0,0,0,0],[1,0,1,0,1],[0,1,0,1,0],[1,1,1,1,1]]) == 2
	@test code_distance([[0,0,0,0,0],[1,1,1,0,0],[0,0,0,1,1],[1,1,1,1,1],[1,0,0,1,1],[0,1,1,0,0]]) == 1
end

# @btime test()

C1 = [[0,0,0,0,0],[1,0,1,0,1],[1,0,0,0,1],[0,1,0,1,0]]
C2 = [[0,0,0,0,0],[1,1,1,0,0],[0,0,0,1,1],[1,1,1,1,1],[1,0,0,1,1],[0,1,1,0,0]]
C3 = [[0,0,0,0,0],[1,0,1,0,1],[0,1,0,1,0],[1,1,1,1,1]]

# println(islinear(C1, 2))#addition
# println(islinear(C2, 2))#addition
# println(islinear(C3, 2))

# println(code_distance(C1))
# println(code_distance(C2))
# println(code_distance(C3))

@show list_span([1, 0, 1, 0, 1, 0], [0, 1, 0, 0, 1, 0], [1, 1, 1, 1, 1, 1], 2)
