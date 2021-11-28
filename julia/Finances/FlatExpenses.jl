using Dates, CSV, DataFrames, DataFramesMeta, Plots, StatsPlots

# const FILENAME = "Ireland-Christall-1FEB2019-to-14AUG2021.csv"
const FILENAME = "Ireland-Christall-14FEB2019-to-27NOV2021.csv"
const PAYEE_NAME = "CONTACT ENERGY LTD"
const DATES_SHEET = "flat_data.csv"

function add_type!(df::DataFrame, colname::Symbol, appendtypes::Type...)
    df[!, colname] =
        Vector{Union{appendtypes..., Base.uniontypes(eltype(df[!, colname]))...}}(df[!, colname])
    return df
end

function parse_dates!(df::DataFrame)
    add_type!(df, :date, Date)
    for (i, d) in enumerate(df.date)
        month_abbr, yr_str = split(d, '-')
        month_num = Dates.monthabbr_to_value(month_abbr, Dates.LOCALES["english"])
        # month_num = Dates.LOCALES["english"].month_abbr_value[month_abbr]
        yr_num = parse(Int, yr_str)
        df[i, :date] = Date(yr_num, month_num)
    end
    
    return df
end

# for testing purposes only
function fill_in_the_blanks!(df::DataFrame)
    add_type!(df, :power, Float64)
    add_type!(df, :internet, Int)
    for (i, r) in enumerate(eachrow(df))
        power = r.power
        internet = r.internet
        if ismissing(power)
            r.power = rand(180.0:0.01:450.0)
        end
        if ismissing(internet)
            r.internet = 79
        end
        df[i, :] = r
    end
    return df
end

function get_power!(df::DataFrame)
	df_all = CSV.read(FILENAME, DataFrame)
    add_type!(df, :power, Float64, Missing)
	i = 1
    for r in eachrow(@subset(df_all, :Payee .== PAYEE_NAME)) # ignore partial (first) month
        i <= nrow(df) || break
        d = Date(r.Date, DateFormat("dd/mm/yy")) + Year(2000)
        if Date(year(d), month(d), 1) != df[i, :date]
			i += 1 # skip month if we have are missing a month in the BNZ spreadsheet
		end
		df[i, :power] = (r.Amount * -1)
		i += 1
    end
    return df
end

function get_internet!(df::DataFrame)
    add_type!(df, :internet, Int)
    for (i, internet) in enumerate(df.internet)
        df[i, :internet] = 79
    end
    return df
end

function construct_power_countmap(df::DataFrame)
    D = Dict{Int, Tuple{Float64, Int}}() # (month_num => (total_paid, month_count))
    for r in eachrow(df)
		r.date == Date(2019, 3) && continue # ignore first month of being here
        month_num = month(r.date)
        total_paid, month_count = get(D, month_num, (0, 0))
        total_paid += r.power
		if !ismissing(total_paid) # don't count a missing month as a month when averaging
        	month_count += 1
		end
		total_paid = ismissing(total_paid) ? 0.0 : total_paid
        D[month_num] = (total_paid, month_count)
    end
    D2 = Dict{String, Float64}() # (month_num => averaged_paid)
    for (k, v) in D
        D2[Dates.LOCALES["english"].months[k]] = first(v) / last(v)
    end
    return D2
end

function plot_avg_hist(D::Dict{String, Float64})
    theme(:solarized)
    
	plt = bar(
        Dates.LOCALES["english"].months,
		Float64[D[m] for m in Dates.LOCALES["english"].months],
        legend = false,
        xticks = (0.5:11.5, Dates.LOCALES["english"].months),
        xrotation = 45,
        fontfamily = font("Times"),
        xlabel = "Month",
        ylabel = "Cost of power (averaged; \$)",
        title = "Power cost average per month at 12 G. Street"
    )
	
	savefig(plt, "power_avg.pdf")
end

function plot_power_internet(df::DataFrame)
	dates_human_readable = String[string(Dates.LOCALES["english"].months_abbr[month(d)], " ", year(d)) for d in df.date]
	theme(:solarized)
	plt = bar(
        dates_human_readable,
		Float64[ismissing(p) ? 0.0 : p for p in df.power],
		legend = :topleft,
        label = "Power",
        xticks = (0.5:(length(df.date) - 0.5), dates_human_readable),
        xrotation = 45,
        fontfamily = font("Times"),
        xlabel = "Month and year",
        ylabel = "Cost (\$)",
        title = "Cost of power and internet at 12 G. Street"
    )
	bar!(
		dates_human_readable,
		df.internet,
		label = "Internet"
	)
	
	savefig(plt, "expenses_raw.pdf")
end

function main()
    # read and parse dataframe
    df = CSV.read(DATES_SHEET, DataFrame)
    parse_dates!(df)
    # fill_in_the_blanks!(df)
    get_power!(df)
    get_internet!(df)
    
	# plot raw data
	plot_power_internet(df)
	
    # get and plot averaged data
    D = construct_power_countmap(df)
    plot_avg_hist(D)
end

res = main()
