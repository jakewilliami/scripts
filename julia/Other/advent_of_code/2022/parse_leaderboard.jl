using Dates

using DotEnv
using HTTP
using JSON

# TODO: allow --day parameter
# TODO: say "n days, m hours, o minutes" instead of "n minutes"

# Usage:
#   julia --project=. parse_leaderboard.jl --day=1


# Statistics structs

struct StarStats
    n::Int
    mins::Float64
end

struct DayStats
    day::Int
    stats::Vector{StarStats}
end

struct UserStats
    name::String
    stats::Vector{DayStats}
end


# Minimal initialisation methods

DayStats(day::Int) = DayStats(day, StarStats[])
UserStats(name::String) = UserStats(name, DayStats[])


# Helper functions

function get_unix_time_since_day_start(dᵢ::Int, ts::Int)
    d = DateTime(2022, 12, dᵢ) + Hour(5)  # Account for EST/UTC–5
    return (ts - datetime2unix(d)) / 60
end


function sort_stats!(stats::Vector{UserStats})
    sort!(stats, by = s -> sum(d.stats[2].mins for d in s.stats))
    return stats
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
                m = get_unix_time_since_day_start(dᵢ, ts)

                # Add star stats to day stats
                star_stats = StarStats(sᵢ, m)
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
                println("        ", lpad(star.n, 2), ": ", round(star.mins, digits = 2), " mins")
            end
        end
    end
end

main()
