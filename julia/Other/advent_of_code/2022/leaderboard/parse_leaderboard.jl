using Dates

using DotEnv
using HTTP
using JSON

# TODO: allow --day parameter
# TODO: take into account number of stars in sorting!

# Usage:
#   julia --project=. parse_leaderboard.jl --day=1


# Statistics structs

struct TimeSummary
    days::Int
    hours::Int
    minutes::Int
    seconds::Int
end

struct StarStats
    n::Int
    time::TimeSummary
    seconds::Float64
end

struct DayStats
    day::Int
    stats::Vector{StarStats}
end

struct UserStats
    name::String
    stats::Vector{DayStats}
    # stars::Int  # TODO
end


# Minimal initialisation methods

DayStats(day::Int) = DayStats(day, StarStats[])
UserStats(name::String) = UserStats(name, DayStats[])


# Helper functions

function get_seconds_since_day_start(dᵢ::Int, ts::Int)
    d = DateTime(2022, 12, dᵢ) + Hour(5)  # Account for EST/UTC–5
    return (ts - datetime2unix(d))
end


function sort_stats!(stats::Vector{UserStats})
    sort!(stats, by = s -> sum(maximum(i.seconds for i in d.stats) for d in s.stats))
    return stats
end


function get_time_summary(seconds::Float64)
    n_minutes_in_day = 3600  # 60 * 60
    n_seconds_in_day = 86_400  # 24 * 60 * 60

    days = seconds ÷ n_seconds_in_day
    seconds %= n_seconds_in_day
    hours = seconds ÷ n_minutes_in_day
    seconds %= n_minutes_in_day
    minutes = seconds ÷ 60
    seconds %= 60

    return TimeSummary(days, hours, minutes, seconds)  # TODO: n days
end


function display_time_summary(t::TimeSummary)
    io = IOBuffer()
    unit_map = Pair{Symbol, Int}[f => getfield(t, f) for f in fieldnames(TimeSummary) if !iszero(getfield(t, f))]

    for (i, (fieldname, value)) in enumerate(unit_map)
        at_last_nonzero_unit = i == lastindex(unit_map)
        at_last_nonzero_unit && print(io, "and ")
        print(io, value, ' ', string(fieldname))
        !at_last_nonzero_unit && print(io, length(unit_map) == 2 ? " " : ", ")
    end

    return String(take!(io))
end


# Pull data

function pull_leaderboard_data(leaderboard_id::String, session_cookie::String)
    uri = "https://adventofcode.com/2022/leaderboard/private/view/$(leaderboard_id).json"
    cookies = Dict{String, String}("session" => session_cookie)
    r = HTTP.get(uri, cookies = cookies)
    return JSON.parse(String(r.body))
end


# Parse function

function parse_user_stats(json_data::Dict{String, Any})
    # Initialise results
    user_stats = UserStats[]

    # Iterate over users
    for (_user_id, data) in json_data["members"]
        # If they have no completed days, skip user
        isempty(data["completion_day_level"]) && continue

        this_user_stats = UserStats(data["name"])

        for dᵢ in 1:25
            dᵢˢ = string(dᵢ)

            # Skip day if haven't done yet
            haskey(data["completion_day_level"], dᵢˢ) || continue

            day_stats = DayStats(dᵢ)
            for sᵢ in 1:2
                sᵢˢ = string(sᵢ)

                # Skip part/level/star if incomplete for this day
                haskey(data["completion_day_level"][dᵢˢ], sᵢˢ) || continue

                # Calculate minutes since problem released
                ts = data["completion_day_level"][dᵢˢ][sᵢˢ]["get_star_ts"]
                s = get_seconds_since_day_start(dᵢ, ts)
                t = get_time_summary(s)

                # Add star stats to day stats
                star_stats = StarStats(sᵢ, t, s)
                push!(day_stats.stats, star_stats)
            end

            # Add day stats to user stats
            push!(this_user_stats.stats, day_stats)
        end

        # Add user stats to results
        push!(user_stats, this_user_stats)
    end

    return user_stats
end


# Main function

function main()
    # Pull leaderboard statistics
    DotEnv.config()
    json_data = pull_leaderboard_data(ENV["LEADERBOARD_ID"], ENV["SESSION_COOKIE"])

    # Parse statistics
    stats = parse_user_stats(json_data)
    sort_stats!(stats)

    # Display results
    for user in stats
        println(user.name, ':')
        for day in user.stats
            println("    Day ", lpad(day.day, 2), ':')
            for star in day.stats
                println("        ", lpad(star.n, 2), ": ", display_time_summary(star.time))
            end
        end
    end
end

main()
