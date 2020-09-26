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
using SpecialFunctions: erfinv # for probit

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
	dfRaw = DataFrame!(CSV.File("motion_coherence_data.csv"; header=4, datarow=5))

	dfPivot = combine(groupby(dfRaw, :condition1)) do df
		μ = mean(df.correct)
    	n = nrow(df)
    (
		correct_mean = μ,
		n = n,
		k = μ * n
	)
	end

	show(dfPivot); println()

	model = glm(@formula(correct ~ condition1) , dfRaw, Binomial(), Probit2AFCLink())
	
	# theme(:solarized)

	@df dfPivot scatter(
		:condition1,
		:correct_mean,
	)
	
	a, b = coef(model)
	
	println(a)
	println(b)

	logit(p) = log(p / (1 - p))
	probit(p) = sqrt(2) * erfinv(2*p - 1)
	Φ⁻¹(z) = probit(z) # statistical notation
	
	
	logit⁻¹(α) = 1 / (1 + exp(-α))
	logit⁻¹(α) = logit⁻¹(α) * 0.5 + 0.5 # shift and squish for 2-AFC
	# probit⁻¹(α) = cdf()
	# Φ(α) = probit⁻¹(α)
	
	
	plot!(x -> logit⁻¹(a + b*x), 0, 0.32)

	# plot!(predict(model))

	# df2 %>%
		# group_by(x) %>%
		# summarise(p = mean(y)) %>%
		# ggplot(aes(x, p)) +
		# geom_point(size = 4, shape = 1) +
		# stat_function(fun = function(x) p(a_p + b_p*x),
		#               aes(color = "Probit")) +
		# stat_function(fun = function(x) l(a_l + b_l*x),
		#               aes(color = "Logit")) +
		# labs(x = "Coherence",
		#      y = "Accuracy",
		#      color = "Fitted Curve") +
		# scale_y_continuous(limits = c(0, 1))

	# savefig(plot, joinpath(homedir(), "Desktop", "PsychometricCurve.pdf"))
end # end main


main()
