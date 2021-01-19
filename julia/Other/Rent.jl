#!/usr/bin/env bash
    #=
    exec julia --project="$(realpath $(dirname $0))" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#
    
using DataFrames, CSV, Dates, DataFramesMeta

const datafile = joinpath("/Volumes", "NO NAME", "my-data", "economy", "bnz", "csv-exports", "ireland-christall", "Ireland-Christall-1JUL2017-to-29DEC2020.csv")
const payee_of_interest = "Christall"

# read the datafile
df = CSV.read(datafile, DataFrame)
# convert dates to dates
df.Date = Date.(df.Date, "dd/mm/yy") .+ Year(2000)
# remove missing payees
df = @where(df, !ismissing(:Payee))
replace!(df.Payee, missing => "Mr. Nobody")
df.Payee = convert(Array{String, 1}, df.Payee)

# filter out Payee's name
df2 = @where(df, contains.(:Payee, payee_of_interest))

function weekof(d::Date)
    m, s = d, d
    
    if Dates.ismonday(d)
        m = d
    else
        while ! Dates.ismonday(m)
            m -= Day(1)
        end
    end
    
    if Dates.issunday(d)
        s = d
    else
        while ! Dates.issunday(s)
            s += Day(1)
        end
    end
    
    return m, s
end

function get_weeks_within_range(start::Date, stop::Date)
    week_bounds = NTuple{2, Date}[]
    d = start
    while d ≤ stop
        week_of = weekof(d)
        week_of ∉ week_bounds && push!(week_bounds, week_of)
        d += Day(7)
    end
    
    return week_bounds
end

function find_missed(df_original::DataFrame)
    df = copy(df_original)
    start, stop = first(df.Date), last(df.Date)
    insertcols!(df, ncol(df), :Week => weekof.(df.Date))
    out = NTuple{3, Union{NTuple{2, Date}, Float64}}[]
    
    for (i, row) in enumerate(eachrow(df))
        week_start, week_end = row.Week
        # println("Checking week $(row.Week)")
        if i ≠ 1 && week_start ≠ last(df[i - 1, :Week]) + Day(1) # check that this week starts where last payment ends
            # a whole bunch of edge cases...
            if row.Amount < 300 # not compensating for a missed week
                if row.Amount > 50 # if not a grocery groceries
                    if df[i - 1, :Amount] < 400 # compensating for paying in advance
                        if df[i + 1, :Amount] < 400 # compensating for paying for last week
                            if df[i + 1, :Week] ≠ df[i + 2, :Week] # checking if next week has two payments (rent compensation)
                                if row.Week ∉ NTuple{2, Date}[i[3] for i in out] # two payments same week
                                    push!(out, (weekof(week_start - Day(1)), row.Amount, row.Week))
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    return out
end

# THIS IDEA IS UNDER CONSTRUCTION
function find_missed_alt(df_original::DataFrame)
    function weeks_omitted(df::DataFrame, S::Symbol, all_weeks::Vector{NTuple{2, Date}})
        filtered_weeks = copy(all_weeks)
        
        for row in eachrow(df)
            filter!(≠(row[S]), filtered_weeks)
        end
        
        return filtered_weeks
    end
    
    df = copy(df_original)
    start, stop = first(df.Date), last(df.Date)
    insertcols!(df, ncol(df), :Week => weekof.(df.Date))
    out = NTuple{3, Union{NTuple{2, Date}, Float64}}[]
    filtered_weeks = weeks_omitted(df, :Week, get_weeks_within_range(start, stop))
    df = @where(df, :Week .∈ Ref(filtered_weeks))
    return filtered_weeks
    
    for (i, row) in enumerate(eachrow(df))
        week_start, week_end = row.Week
        push!(out, (weekof(week_start - Day(1)), row.Amount, row.Week))
    end
    
    return out
end

for (missed_week, amount, current_week) in find_missed(df2)
    println("No payment at week $missed_week; paid $amount this week $current_week")
end
