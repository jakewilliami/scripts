using Dates

using JSON

# julia --project=. parse_leaderboard.jl --day=1 '<JSON DATA>'

function get_unix_time_since_day_start(dᵢ::Int, ts::Int)
    d = DateTime(2022, 12, dᵢ) + Hour(5)  # Account for EST/UTC–5
    return (ts - datetime2unix(d)) / 60
end

function main(json_data::String)
    for (_user_id, data) in JSON.parse(json_data)["members"]
        isempty(data["completion_day_level"]) && continue
        println(data["name"], ':')
        for dᵢ in 1:25
            dᵢˢ = string(dᵢ)
            haskey(data["completion_day_level"], dᵢˢ) || continue
            println("    Day ", lpad(dᵢˢ, 2), ':')
            for sᵢ in 1:2
                sᵢˢ = string(sᵢ)
                haskey(data["completion_day_level"][dᵢˢ], sᵢˢ) || continue
                ts = data["completion_day_level"][dᵢˢ][sᵢˢ]["get_star_ts"]
                m = get_unix_time_since_day_start(dᵢ, ts)
                println("        ", lpad(sᵢˢ, 2), ": ", m, " mins")
            end
        end
    end
end

main(ARGS[1])
