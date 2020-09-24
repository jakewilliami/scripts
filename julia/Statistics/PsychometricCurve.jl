#!/usr/bin/env bash
    #=
    exec julia --project="$(realpath $(dirname $0))" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#

using DataFrames
using CSV
using FreqTables
using GLM
# using Plots
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
	dfRaw = DataFrame!(CSV.File("motion_coherence_data.csv"; header=4, datarow=5))
   	# show(dfRaw, summary=false)
	# dfPivot = freqtable(dfRaw, :Response, :Condition)
	# println(dfRaw)
	# println(names(dfRaw))

	# construct data frame grouped by condition, with the mean and length of those correct, as well as
	# dfPivot = combine(groupby(dfRaw, :condition1), :correct => mean, :correct => length)

	# selecting certain data
	# data[:, [x for x in names(data) if x != :column1]]

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

	# show(dfPivot)

	# dfPivot = combine(groupby(dfRaw, :condition1)) do df
        # (mean = mean(dfRaw.correct), n = nrow(dfRaw))
    # end
	# println(dfPivot)

	# numberPresent = count(x -> isequal(x,"Present"), dfRaw[!, 1])
	# numberAbsent = count(x -> isequal(x,"Absent"), dfRaw[!, 1])


	# cdf(d::UnivariateDistribution, x::Real)

	# presentRate = dfPivot[:,2] / numberPresent
	# absentRate = dfPivot[:,1] / numberAbsent
	
	# x = presentRate
	# y = absentRate
	
	

	# dat <- data.frame(
	#     by = as.numeric(levels(dPivot$by))[dPivot$by],
	#     correct = dPivot$correct,
	#     n = dPivot$n
	# )
	
	# dat$k <- dat$correct * dat$n
	
	# model <- glm(cbind(k, n-k) ~ 1 + by, data = dat, family = binomial(mafc.probit(2)))
   # xseq  <- seq(0, 5, length.out = 1000)
   # yseq  <- predict(model, newdata = data.frame(by = xseq), type = "response")

	# intermediate_df = [k, n-k]
	# glm \equiv fit(GeneralizedLinearModel, ...)





	# dfPivot.y = dfPivot.k ./ dfPivot.n
	
	# model = glm(@formula(y ~ condition1), dfPivot, Binomial(), ProbitLink(); wts=dfPivot.n)
	# xseq = 0:5:1000
	# yseq = predict(model)
	# plot(xseq, yseq)

	println(glm(@formula(correct ~ condition1) , dfRaw, Binomial(), Probit2AFCLink()))

	@df dfPivot scatter(
		:correct_mean,
		:k,
		
	)

	df2 %>%
	  group_by(x) %>%
	  summarise(p = mean(y)) %>%
	  ggplot(aes(x, p)) +
	  geom_point(size = 4, shape = 1) +
	  stat_function(fun = function(x) p(a_p + b_p*x),
	                aes(color = "Probit")) +
	  stat_function(fun = function(x) l(a_l + b_l*x),
	                aes(color = "Logit")) +
	  labs(x = "Coherence",
	       y = "Accuracy",
	       color = "Fitted Curve") +
	  scale_y_continuous(limits = c(0, 1))


	# show(dfPivot)

	# lm(@formula(Y ~ X), data)
	# Y ~ 1 + X
	# plot = model() =
	# plot = glm()
	# model() =
	# plot = curve_fit(model, )

	# savefig(plot, joinpath(homedir(), "Desktop", "PsychometricCurve.pdf"))
end # end main


main()
