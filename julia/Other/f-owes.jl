using Dates, DataFrames, CSV

initial_value = 30

# range_of_rates = 0.5:0.5:100
range_of_rates = 200:-0.5:0.5
range_of_dates = Date(2020, 12, 10):Day(1):Date(2022, 12, 31)

df = DataFrame(vcat(String, [Float64 for _ in 1:length(collect(range_of_rates))]), vcat(:date, [Symbol(string(i, "%")) for i in range_of_rates]), length(collect(range_of_dates)))

for (date_idx, day) in enumerate(range_of_dates)
    date_vec = Union{Float64, String}[string(Dates.dayname(day), ", ", Dates.day(day), " ", Dates.monthname(day), " ", Dates.year(day))]
    for (percent_idx, percent) in enumerate(range_of_rates)
        new_owed = initial_value + (initial_value * ((percent / 100) / 365) * (date_idx - 1))
        push!(date_vec, new_owed)
    end
    df[date_idx, :] .= date_vec
end

CSV.write("$(homedir())/Desktop/f-owes.csv", df)

df
