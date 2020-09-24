#!/usr/bin/env bash
    #=
    exec julia --project="$(realpath $(dirname $0))" --color=yes --startup-file=no -e "include(popfirst!(ARGS))" \
    "${BASH_SOURCE[0]}" "$@"
    =#

using DataFrames
using Distributions
using GLM
using Plots
using Random

x = repeat(0.04:0.04:0.32, 200000)
# I like to shuffle my data. Keeps the subjects on their toes
shuffle!(x)

N = length(x)

# Need to define four functions for our link functions
# 1) linkfun: Return `η`, the value of the linear predictor for link `L` at mean `μ`.
#    This is the function g such that g(y) = η = α + βx
# 2) linkinv: Return `μ`, the mean value, for link `L` at linear predictor value `η`.
#    This is the inverse function of g such that y = μ = g⁻¹(η)
# 3) mueta: Return the derivative of `linkinv`, `dμ/dη`, for link `L` at linear predictor value `η`.
#    GLMs use a form of gradient descent to find solutions, so need the derivative
# 4) inverselink: Return a 3-tuple of the inverse link, the derivative of the inverse link, and when appropriate, the variance function `μ*(1 - μ)`.
#    The variance function is returned as NaN unless the range of μ is (0, 1)
import GLM: Link, Link01, linkfun, linkinv, mueta, inverselink

Φ(x::Real)   = cdf(Normal(), x)
Φ⁻¹(x::Real) = quantile(Normal(), x)
φ(x::Real)   = pdf(Normal(), x)

struct Probit2AFCLink <: Link end

# overloading
linkfun(::Probit2AFCLink, μ::Real) = Φ⁻¹(2 * max(μ, nextfloat(0.5)) - 1)
linkinv(::Probit2AFCLink, η::Real) = (1 + Φ(η)) / 2
mueta(::Probit2AFCLink,   η::Real) = φ(η) / 2
function inverselink(::Probit2AFCLink, η::Real)
    μ = (1 + Φ(η)) / 2
    d = φ(η) / 2
    return μ, d, oftype(μ, NaN)
end

# Simple GLM ------------------------------------------------------------------
x = repeat(0.04:0.04:0.32, 20)
shuffle!(x)
N = length(x)

a, b = -4.5, 25
η = a .+ b .* x
μ = cdf.(Normal(), η)
y = rand.(Bernoulli.(μ))

df = DataFrame(y = y, x = x)
println(glm(@formula(y ~ x) , df, Binomial(), ProbitLink()))

# 2-AFC Probit GLM-------------------------------------------------------------
μ = 0.5 .+ 0.5 * cdf.(Normal(), η)
y = rand.(Bernoulli.(μ))
df = DataFrame(y = y, x = x)
println(glm(@formula(y ~ x) , df, Binomial(), Probit2AFCLink()))
