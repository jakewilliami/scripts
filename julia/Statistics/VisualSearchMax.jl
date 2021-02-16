#!/usr/bin/env bash
    #=
    exec julia --project="$(realpath $(dirname $0))" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#

using CSV, DataFrames, Query, Statistics, ANOVA, GLM, StatsPlots, DataFramesMeta

# df = DataFrame(CSV.File("data-task-zfsd.csv", header = true)) # MI
df = DataFrame(CSV.File("data-task-mjco.csv", header = true)) # ZC

function make_pivot(df::DataFrame)
	new_df = @where(df, :Correct .== 1)
	
	df_pivot = @from i in new_df begin
		# @where isone(i.TargetCondition) && isone(i.Correct) # response correct
		# @where i.Correct .== 1 # repsonse correct
		@select {i.TargetCondition, i.ResponseTime}
		@groupby :TargetCondition
		@collect DataFrame
	end
	df_pivot = combine(groupby(DataFrame(df_pivot), :TargetCondition), :ResponseTime => mean)
	
	return df_pivot
end

function make_plot(df_pivot::DataFrame)
	line = lm(@formula(ResponseTime_mean ~ TargetCondition), df_pivot)
	line_coeffs = coef(line)
	equation = "y = $(round(line_coeffs[2], sigdigits = 3))x + $(round(line_coeffs[1], sigdigits = 3))"

	theme(:solarized)
	plot = @df df_pivot scatter(
		:TargetCondition,
		:ResponseTime_mean,
		title = "Response Time of Visual Searches",
		label = false,
		xaxis = "Set Size",
		yaxis = "Response Time",
		xlim = (0, maximum(:TargetCondition)),
	    ylim = (0, maximum(:ResponseTime_mean)),
		fontfamily = font("Times"),
		smooth = true,
		annotations = (3, 1100, Plots.text(equation, 8, :white, :left))
	)

	savefig(plot, joinpath(homedir(), "VisualSearch.pdf"))
	println("Plot saved at ", joinpath(homedir(), "VisualSearch.pdf"))
end

function analysis_of_variance()
	analysis_df = @from i in df begin
		# @where isone(i.TargetCondition) && isone(i.Correct)
		@where isone.(i.Correct)
		@select {i.TargetCondition, i.ResponseTime, i.TargetConditionCoded}
		@groupby :TargetCondition, :TargetConditionCoded # previously stim_no
		@collect DataFrame
	end
	analysis_df = combine(groupby(DataFrame(analysis_df), [:TargetCondition, :TargetConditionCoded]), :ResponseTime => mean)
	categorical!(analysis_df, :TargetCondition)

	model = fit(LinearModel, @formula(ResponseTime_mean ~ TargetCondition), analysis_df, contrasts = Dict(:ResponseTime_mean => EffectsCoding()))

	println(anova(model))
end

make_pivot(df)
# make_plot(make_pivot(df))
# analysis_of_variance()
