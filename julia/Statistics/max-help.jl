#!/usr/bin/env bash
    #=
    exec julia --project="$(realpath $(dirname $0))" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#

using Distributions, HypothesisTests, DataFrames, CSV, GLM, ANOVA, StatsBase

df = DataFrame(CSV.File(joinpath(dirname(@__FILE__), "test3.data.csv")))

#= ?????????
Perform a chi-squared test, to test whether or not Occupation (variable name = "occupation") and Sex (variable name = "sex") are associated.  Test at the 5% level.
=#
cquantile(Chisq(11), 1 - 0.05) # 11 is the degrees of freedom I think.


#=
Perform an Analysis of Variance test whether or not the population average Incomes (variable name = "income") vary by Ethnicity (variable name = "ethnicity").  Test at the 5% level.
=#
# dependent = income
# independent = ethnicity
# ensure ethnicity is categorical
categorical!(df, :ethnicity)
# fit a linear model
model = fit(LinearModel, @formula(income ~ ethnicity), df, contrasts = Dict(:income => EffectsCoding()))
# perform the ANOVA
anova_output = anova(model)
println("The following is the results of an ANOVA on Incomes versus Ethnicity, tested at the default 5% significance level.")
println(anova_output, "\n")


#= ????????
A confidence interval has width 21 and is centered on a sample mean of 30 as its point estimate of the mean.  What is the margin of error of the confidence interval?
=#
# calculate confidence interval
μ = 30
interval_width = 21
ci = (interval_width / 2) / μ
# zscore(X, [μ, σ]); Compute the z-scores of X, optionally specifying a precomputed mean μ and standard deviation σ. z-scores are the signed number of standard deviations above the mean that an observation lies, i.e. (x - μ) / σ.
# score = zscore(μ)
# println(score)

#=
If X is binomial with parameters n = 9 and p = 0.32, what is P(X = 6)?  Give your answer to 4 decimal places
=#
n = 9
p = 0.32
X = 6
# get distribution parameters
D = Binomial(n, p)
# calculate probability
probability = pdf(D, X)
println("The probability of X = $X given a binomial distribution with n = $n and p = $p is $(round(probability, digits = 4)).\n")

#=
If X is a binomial with n = 6 and p = 0.48, what is P(1 ≤ X ≤ 3)?  Give your answer to four decimal places.
=#
n = 6
p = 0.48
k1 = 1
k2 = 3
# get distribution parameters
D = Binomial(n, p)
# calculate probability
probability =  cdf(D, k2) - cdf(D, k1)
println("The probability of $k1 ≤ X ≤ $k2 given a binomial distribution with n = $n and p = $p is $(round(probability, digits = 4)).\n")

#=
If X ~ N(5.7, 1.4^2), what is P(X > 6.2)?  Give your answer to four decimal places.
=#
μ = 5.7
σ = 1.4
k = 6.2 # upper bound
# get distribution parameters
D = Normal(μ, σ)
# calculate probability using the complement cdf
probability = ccdf(D, k)
println("The probability of X > $k given a normal distribution with μ = $μ and σ = $σ is $(round(probability, digits = 4)).\n")
