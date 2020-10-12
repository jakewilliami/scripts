#!/usr/bin/env bash
    #=
    exec julia --project="$(realpath $(dirname $0))" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#

using CSV, DataFrames, Query, Statistics, ANOVA, GLM, StatsPlots

df = DataFrame(CSV.File(joinpath(dirname(@__FILE__), "data.csv"), header = false, delim = "\t"))
names!(df, map(Symbol, ["block", "stim_no", "trial_type", "set_size", "response", "RT"]))

function make_plot()
	df_pivot = @from i in df begin
		@where isone(i.trial_type) && isone(i.response)
		@select {i.set_size, i.RT}
		@groupby :set_size
		@collect DataFrame
	end
	df_pivot = combine(groupby(DataFrame(df_pivot), :set_size), :RT => mean)

	line = lm(@formula(RT_mean ~ set_size), df_pivot)
	line_coeffs = coef(line)
	equation = "y = $(round(line_coeffs[2], sigdigits = 3))x + $(round(line_coeffs[1], sigdigits = 3))"

	theme(:solarized)
	plot = @df df_pivot scatter(
		:set_size,
		:RT_mean,
		title = "Response Time of Visual Searches",
		label = false,
		xaxis = "Set Size",
		yaxis = "Response Time",
		xlim = (0, maximum(:set_size)),
	    ylim = (0, maximum(:RT_mean)),
		fontfamily = font("Times"),
		smooth = true,
		annotations = (3, 1100, Plots.text(equation, 8, :white, :left))
	)

	savefig(plot, joinpath(dirname(@__FILE__), "VisualSearch.pdf"))
	println("Plot saved at ", joinpath(dirname(@__FILE__), "VisualSearch.pdf"))
end

function analysis_of_variance()
	analysis_df = @from i in df begin
		@where isone(i.trial_type) && isone(i.response)
		@select {i.set_size, i.RT, i.stim_no}
		@groupby :set_size, :stim_no
		@collect DataFrame
	end
	analysis_df = combine(groupby(DataFrame(analysis_df), [:set_size, :stim_no]), :RT => mean)
	categorical!(analysis_df, :set_size)

	model = fit(LinearModel, @formula(RT_mean ~ set_size), analysis_df, contrasts = Dict(:RT_mean => EffectsCoding()))

	println(anova(model))
end

make_plot()
analysis_of_variance()
