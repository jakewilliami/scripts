#!/usr/bin/env bash
    #=
    exec julia --project="$(realpath $(dirname $0))" --color=yes --startup-file=no -e "include(popfirst!(ARGS))" \
    "${BASH_SOURCE[0]}" "$@"
    =#

using Polynomials
using Test: @test
using BenchmarkTools: @btime

import Base.mod

mod(p::Polynomial, n::Integer) = Polynomial(mod.(p.coeffs, n))

function test()
	p = Polynomial([1, 1, 2, 0, 1, 2, 1])
	q = Polynomial([2, 1, 1])
	a = Polynomial([0, 1, 0, 1, 0, 0, 1])
	b = Polynomial([1, 0, 1])

	@test mod(rem(p, q), 3) == Polynomial([1, 1])
	@test mod(rem(a, b), 2) == Polynomial([1])
end

@btime test()
