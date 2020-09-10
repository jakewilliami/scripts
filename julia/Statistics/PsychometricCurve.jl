#!/usr/bin/env bash
    #=
    exec julia --project="~/scripts/julia/Statistics/" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#

using DataFrames: DataFrame!
using CSV: File
using FreqTables: freqtable
using GLM
using Plots



# d <- read.csv('motion_coherence_data_1.csv')
#
# # construct pivot table
# dPivot <- pivot(data=d, compute=mean, value=correct, rows_by=c(condition1))
#
# # construct a dataframe to hold pivot data (and to parse the `by` column into something that is ggplot friendly, as for some reason was of class `factor` rather than `numeric`)
# dat <- data.frame(
#     by = as.numeric(levels(dPivot$by))[dPivot$by],
#     correct = dPivot$correct,
#     n = dPivot$n
# )
#
# # appdent dat data frame with the proportion of correct responses
# dat$k <- dat$correct * dat$n
#
# myTheme <- theme(plot.title = element_text(family = "Helvetica", face = "bold", size = (15)),
#     axis.title = element_text(family = "Helvetica", size = (10), colour = "steelblue4"),
#     axis.text = element_text(family = "Courier", colour = "cornflowerblue", size = (10)))
#
# # construct plot
# p <- ggplot(dat, aes(by, correct)) +
#     geom_point(colour = "orange") +
#     scale_x_continuous(limits = c(0, 0.35),
#                      breaks = seq(0, 0.35, 0.05)) +
#     myTheme +
#     ggtitle("Performance of Motion Coherence") +
#     theme(plot.title = element_text(hjust = 0.5)) +
#     labs(y="Accuracy", x = "Coherence")
#
# # construct psychometric model
# model <- glm(cbind(k, n-k) ~ 1 + by, data = dat, family = binomial(mafc.probit(2)))
# xseq  <- seq(0, 5, length.out = 1000)
# yseq  <- predict(model, newdata = data.frame(by = xseq), type = "response")
#
# # fit model to plot
# curve <- tibble(xseq, yseq)
# p + geom_line(data = curve, aes(xseq, yseq), color = "steelblue")


function main()
	dfRaw = DataFrame!(File("data.csv"))
	dfPivot = freqtable(dfRaw, :Response, :Condition)

	numberPresent = count(x -> isequal(x,"Present"), dfRaw[!, 1])
	numberAbsent = count(x -> isequal(x,"Absent"), dfRaw[!, 1])

	# cdf(d::UnivariateDistribution, x::Real)

	presentRate = dfPivot[:,2] / numberPresent
	absentRate = dfPivot[:,1] / numberAbsent
	
	x = presentRate
	y = absentRate
	
	# dat <- data.frame(
	#     by = as.numeric(levels(dPivot$by))[dPivot$by],
	#     correct = dPivot$correct,
	#     n = dPivot$n
	# )
	
	# dat$k <- dat$correct * dat$n
	
	# model <- glm(cbind(k, n-k) ~ 1 + by, data = dat, family = binomial(mafc.probit(2)))
   # xseq  <- seq(0, 5, length.out = 1000)
   # yseq  <- predict(model, newdata = data.frame(by = xseq), type = "response")
	
	
	plot = lm(@formula(y ~ x), dfPivot)
	
	savefig(plot, joinpath(homedir(), "Desktop", "PsychometricCurve.pdf"))
end


main()
