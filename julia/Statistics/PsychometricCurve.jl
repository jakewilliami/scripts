#!/usr/bin/env bash
    #=
    exec julia --project="$(realpath $(dirname $0))" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#

using DataFrames
using CSV
using FreqTables
using GLM
using StatsPlots
using Distributions
using Statistics

const Dist = Distributions

import GLM: Link, Link01, linkfun, linkinv, mueta, inverselink

#=
Need to define four functions for our link functions
	1) linkfun: Return `η`, the value of the linear predictor for link `L` at mean `μ`.
   This is the function g such that g(y) = η = α + βx
	2) linkinv: Return `μ`, the mean value, for link `L` at linear predictor value `η`.
   This is the inverse function of g such that y = μ = g⁻¹(η)
	3) mueta: Return the derivative of `linkinv`, `dμ/dη`, for link `L` at linear predictor value `η`.
   GLMs use a form of gradient descent to find solutions, so need the derivative
	4) inverselink: Return a 3-tuple of the inverse link, the derivative of the inverse link, and when appropriate, the variance function `μ*(1 - μ)`.
   The variance function is returned as NaN unless the range of μ is (0, 1)
=#

Φ(x::Real)   = Dist.cdf(Dist.Normal(), x)
Φ⁻¹(x::Real) = Dist.quantile(Dist.Normal(), x)
φ(x::Real)   = Dist.pdf(Dist.Normal(), x)

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


function main()
	dfRaw = DataFrame!(CSV.File(joinpath(dirname(@__FILE__), "motion_coherence_data.csv"); header=4, datarow=5))

	dfPivot = combine(groupby(dfRaw, :condition1)) do df
		μ = mean(df.correct)
    	n = nrow(df)
    (
		correct_mean = μ,
		n = n,
		k = μ * n
	)
	end

	# show(dfPivot); println()

	model = glm(@formula(correct ~ condition1) , dfRaw, Binomial(), Probit2AFCLink())
	
	theme(:solarized)

	plot = @df dfPivot scatter(
		:condition1,
		:correct_mean,
		title = "Psychometric Curve of Motion Coherence",
		label = false,
		xaxis = "Coherence",
		yaxis = "Accuracy",
		fontfamily = font("Times"),
	)
	
	a, b = coef(model)
	
	println("The following coefficients have been found to maximise best fit based on your datapoints.")
	println("a = ", a)
	println("b = ", b)

	logit(p) = log(p / (1 - p))
	logit⁻¹(α) = 1 / (1 + exp(-α))
	logit⁻¹(α) = logit⁻¹(α) * 0.5 + 0.5 # shift and squish for 2-AFC
	logit2afc⁻¹(α) = 0.5 + 0.5 / (1 + exp(-α))

	probit(p) = Dist.quantile(Dist.Normal(), p)
	probit⁻¹(x) = Dist.cdf(Dist.Normal(), x)
	Φ⁻¹(z) = probit(z) # statistical notation
	Φ(α) = probit⁻¹(α) # statistical notation
	probit2afc⁻¹(x) = probit⁻¹(x) * 0.5 + 0.5 # shift and squish for 2-AFC
	
	plot!(plot, x -> probit2afc⁻¹(a + b*x), 0, 0.32, label = "Probit Link")
	plot!(plot, x -> logit2afc⁻¹(a + b*x), 0, 0.32, label = "Logit Link")
	# plot_all = plot!(plot_logit, x -> probit2afc⁻¹(a + b*x), 0, 0.32, label = "Probit Link")

	savefig(plot, joinpath(dirname(@__FILE__), "PsychometricCurve.pdf"))
	
	println("\nFigure saved at ", joinpath(dirname(@__FILE__), "PsychometricCurve.pdf"))
end # end main


main()
