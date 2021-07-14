using Dates, DataFrames, StatsBase, StatsPlots
using Plots, Plots.PlotMeasures

workdir = joinpath(homedir(), "Desktop", "Assorted Personal Documents", "Work")
RELATIVE_PLOTS_DIR = "plots"
NAMING_CONSISTENCY = Dict{AbstractString, AbstractString}(
    "Sarah Clarke" => "Sarah Clark",
    "Lee-Ann" => "Lee-Ann Waters",
    "" => "Undefined",
)

# helper function for tex parsing
function _construct_tex_block_bound(s_context::AbstractString, s::AbstractString)
    return string("\\", s_context, "{", s, "}")
end
_construct_tex_block_bound(s::AbstractString, t::Symbol) = 
    _construct_tex_block_bound(string(t), s)
_construct_tex_block_bound(s::AbstractString) = 
    (_construct_tex_block_bound(s, :begin), _construct_tex_block_bound(s, :end))

# get the raw tabular from a tex file
function read_data_table(texfile::AbstractString)
    ignore_lines = [
        raw"%",
        raw"\hline",
        raw"\textsc",
        raw"\endfirsthead",
        raw"\endhead",
        raw"\endfoot",
        raw"\endlastfoot",
        raw"\emph",
        raw"\textbf{Date of Duty}"
    ]

    tabular_begin, tabular_end = _construct_tex_block_bound("tabular")
    longtable_begin, longtable_end = _construct_tex_block_bound("longtable")
    
    out_table = String[]
    readtable = false
    for line in readlines(texfile)
        line = strip(line)
        any(startswith(line, i) for i in ignore_lines) && continue
        if startswith(line, tabular_end) || startswith(line, longtable_end)
            readtable = false
            continue
        end
        if startswith(line, tabular_begin) || startswith(line, longtable_begin)
            readtable = true
            continue
        end
        readtable || continue
        push!(out_table, line)
    end
    
    return out_table
end

function parse_date(D::AbstractString)
    date_match1 = match(r"(\d+\.\d+\.\d+)", D)
    date_match2 = match(r"\\.*{(.*)}", D)
    
    date_raw = nothing
    if !isnothing(date_match1)
        date_raw = date_match1.captures[1]
    elseif !isnothing(date_match2)
        date_raw = date_match2.captures[1]
    end

    return (isnothing(date_raw) || (!isnothing(date_raw) && isempty(date_raw))) ? 
        missing : Date(date_raw, dateformat"dd.mm.yyyy")
end

function parse_time(time_raw::AbstractString)
    time_str, meridiem = match(r"(\d+:?:?.?\d?\d?)\s?([ap]?\.?m?\.?)", time_raw).captures
    time_str = replace(replace(time_str, "::" => ':'), '.' => ':')
    if isnothing(match(r"\d+:\d+", time_str))
        time_str = strip(time_str) * ":00"
    end
    meridiem = isnothing(meridiem) ? "a.m." : meridiem
    modifier = meridiem == "p.m." ? Hour(12) : Hour(0)
    return Time(time_str) + modifier
end

function parse_datetime(day_date::Union{Date, Missing}, start_time::AbstractString, finish_time::AbstractString)
    t1 = parse_time(start_time)
    t2 = parse_time(finish_time)
    
    if ismissing(day_date)
        return (t1, t2)
    end
    
    return (DateTime(day_date, t1), DateTime(day_date, t2))
end

# iterate over tex files and construct a dataframe
function construct_work_data(workdir::AbstractString)
    df = DataFrame(:timesheet_number => Int[], :date => Union{Date, Missing}[], :directed_by => String[], :start_time => Union{DateTime, Time}[], :finish_time => Union{DateTime, Time}[], :nhours => Float64[])
    n = 0
    while true
    # for dir in readdir(workdir, sort = true)
        n += 1
        dir = "Time Sheet $n"
        full_dir_path = joinpath(workdir, dir)
        # isdir(full_dir_path) || continue
        isdir(full_dir_path) || break
        for file in readdir(full_dir_path)
            basename, ext = splitext(file)
            ext == ".tex" || continue
            full_file_path = joinpath(full_dir_path, file)
            raw_table = read_data_table(full_file_path)
            for (i, line) in enumerate(raw_table)
                line = replace(line, '$' => "")
                line = replace(line, raw"\hline" => "")
                splitline = split(line, '&')
                possible_date = parse_date(splitline[1])
                j = 0
                while true
                    j += 1
                    if ismissing(possible_date)
                        i == j && break
                        prev_date_raw = split(raw_table[i - j], '&')[1]
                        possible_date = parse_date(prev_date_raw)
                    end
                    if !ismissing(possible_date)
                        break
                    end
                end
                directed_by = get(NAMING_CONSISTENCY, splitline[end - 2], splitline[end - 2])
                temporal_domain_raw = splitline[end - 1]
                start_time, finish_time = parse_datetime(possible_date, split(temporal_domain_raw, "--")...)
                nhours_str = strip(splitline[end], '\\')
                nhours = parse(Float64, nhours_str)
                
                push!(df, [n, possible_date, directed_by, start_time, finish_time, nhours])
            end
        end
    end
    
    return df
end

function bar_per_day(df::DataFrame, outname::String)
    outname = joinpath(RELATIVE_PLOTS_DIR, outname)
    day_frequency_map = countmap(ismissing(d) ? "Missing" : dayname(d) for d in df.date)
    days_ordered = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    plt = bar(days_ordered, [day_frequency_map[d] for d in days_ordered], label = false, xlabel = "Day of week", ylabel = "Number of times called out")
    savefig(plt, outname)
    return outname
end

function bar_per_day_in_hours(df::DataFrame, outname::String)
    outname = joinpath(RELATIVE_PLOTS_DIR, outname)
    day_and_hours_map = Dict{String, Float64}()
    for r in eachrow(df)
        hrs = r.nhours
        day_of_week = dayname(r.date)
        day_and_hours_map[day_of_week] = get(day_and_hours_map, day_of_week, 0) + hrs
    end
    days_ordered = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    plt = bar(days_ordered, [day_and_hours_map[d] for d in days_ordered], label = false, xlabel = "Day of week", ylabel = "Total number of hours called out for")
    savefig(plt, outname)
    return outname
end

function plot_average_callout_length(df::DataFrame, outname::String)
    outname = joinpath(RELATIVE_PLOTS_DIR, outname)
    plt = boxplot(df.nhours, label = false, ylabel = "Hours per call-out", ylim = (0, round(Int, maximum(df.nhours), RoundUp)))
    savefig(plt, outname)
    return outname
end

# currently not working!
function _plot_freq_per_fd(df::DataFrame, outname::String)
    outname = joinpath(RELATIVE_PLOTS_DIR, outname)
    fd_frequency_map = countmap(df.directed_by)
    plt = bar(fd_frequency_map, label = false,
              xlabel = "Funeral director", ylabel = "Number of times called out", 
              xticks = (0.5:(length(fd_frequency_map) - 0.5), keys(fd_frequency_map)), xtickrotation = 45)
    savefig(plt, outname)
    return outname
end
function plot_freq_per_fd(df::DataFrame, outname::String)
    outname = joinpath(RELATIVE_PLOTS_DIR, outname)
    # fd_frequency_map = countmap(filter(c -> Int(c) ∈ 65:90, fd) for fd in df.directed_by if fd != "Undefined") # extract capital letters
    fd_frequency_map = countmap(join(getindex.(split(fd, ' '), 1)) for fd in df.directed_by if fd != "Undefined") # extract first initials
    plt = bar(fd_frequency_map, label = false, xlabel = "Funeral director", ylabel = "Number of times called out", xticks = (0.5:(length(fd_frequency_map) - 0.5), keys(fd_frequency_map)))
    savefig(plt, outname)
    return outname
end

function plot_freq_per_fd_in_hours(df::DataFrame, outname::String)
    outname = joinpath(RELATIVE_PLOTS_DIR, outname)
    fd_and_hours_map = Dict{String, Float64}()
    for r in eachrow(df)
        fd_full = r.directed_by
        fd_full == "Undefined" && continue
        hrs = r.nhours
        # fd = filter(c -> Int(c) ∈ 65:90, fd_full) # extract capital letters
        fd = join(getindex.(split(fd_full, ' '), 1))
        fd_and_hours_map[fd] = get(fd_and_hours_map, fd, 0) + hrs
    end
    plt = bar(fd_and_hours_map, label = false, xlabel = "Funeral director", ylabel = "Total number of hours called out for", xticks = (0.5:(length(fd_and_hours_map) - 0.5), keys(fd_and_hours_map)))
    savefig(plt, outname)
    return outname
end

function plot_average_callout_length_per_fd(df::DataFrame, outname::String)
    outname = joinpath(RELATIVE_PLOTS_DIR, outname)
    unique_funeral_directors = unique(df.directed_by)
    P, T = ([], [])
    for fd_full in unique_funeral_directors
        fd_full == "Undefined" && continue
        # fd = filter(c -> Int(c) ∈ 65:90, fd_full) # extract capital letters
        fd = join(getindex.(split(fd_full, ' '), 1))
        p = boxplot([r.nhours for r in eachrow(df) if r.directed_by == fd_full], 
                    xaxis = false, label = false, xticks = false)
        # fd_full == unique_funeral_directors[end] && ylabel!("Hours per call-out")
        push!(P, p)
        push!(T, fd)
    end
    plt = StatsPlots.plot(
                P...,
                title = reshape(T, 1, length(T)),
                layout = (length(T) ÷ (length(T) ÷ 4), length(T) ÷ (length(T) ÷ (length(T) ÷ 4))),
                link = :y,
                # ylabel = "Hours per call-out",
                ylim = (0, round(Int, maximum(df.nhours), RoundUp))
                )
    savefig(plt, outname)
    return outname
end

function plot_probability_of_callout_per_day(df::DataFrame, outname::String)
    function _previous_wednesday(d::Date)
        while true
            if dayname(d) == "Wednesday"
                return d
            end
            d -= Day(1)
        end
    end
    outname = joinpath(RELATIVE_PLOTS_DIR, outname)
    probabilities = Dict{String, Float64}()
    data_view = Dict{String, Dict{Symbol, Union{Number, Date}}}()
    starting_wednesdays = Date[]
    used_dates = Date[]
    # for r in eachrow(unique(df, :date))
    for r in eachrow(df)
        this_date = r.date
        this_day_name = dayname(this_date)
        default_data = Dict{Symbol, Union{Number, Date}}(:count => 0, :total_count => 0, :week_start => Date(1, 1, 1))
        
        # add day data to day name
        this_data = get(data_view, this_day_name, default_data)
        this_data[:count] += 1
        
        # add # need to get total counts
        starting_wednesday = _previous_wednesday(this_date)
        this_data[:week_start] = starting_wednesday
        if starting_wednesday ∉ starting_wednesdays
            push!(starting_wednesdays, starting_wednesday)
        end
        
        # add this data to the data view
        data_view[this_day_name] = this_data
    end
    # need to get total counts
    for d_start in starting_wednesdays
        d_end = d_start + Week(1) - Day(1)
        for d in d_start:Day(1):d_end
            data_view[dayname(d)][:total_count] += 1
        end
    end
    # calculate probabilities
    for (k, v) in data_view
        probabilities[k] = v[:count] / v[:total_count]
    end
    # return probabilities
    
    # plt = scatter()
    days_ordered = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    plt = bar(days_ordered, [probabilities[d] for d in days_ordered], label = false, xlabel = "Day of week", ylabel = "Relative probability of being called out", yticks = false, left_margin = 5mm)
    savefig(plt, outname)
    return outname
end

df = construct_work_data(workdir)

# bar_per_day(df, "BarPerDayByFrequency.pdf")
# bar_per_day_in_hours(df, "BarPerDayByHours.pdf")
# plot_average_callout_length(df, "AverageCalloutLength.pdf")
# plot_freq_per_fd(df, "BarPerFuneralDirectorFrequency.pdf")
# plot_freq_per_fd_in_hours(df, "BarPerFuneralDirectorByHours.pdf")
# plot_average_callout_length_per_fd(df, "AverageCalloutLengthPerFuneralDirector.pdf")
plot_probability_of_callout_per_day(df, "ProbabilityPerDayByFrequency.pdf")

#=
Plot ideas:
  - Frequency per director (box)
  - Total hours per director (bar)
  - Frequency per day (box)
  - Frequency per month (box)
  - Frequency per year (box)
  - Number of hours all time (line)
  - 
=#
