using DataFrames, DelimitedFiles

const datafile = "inputs/data2.csv"

# clean data
function clean_data(raw_data::DataFrame)
    data = DataFrame(num1 = Int[], num2 = Int[], letter = Char[], password = String[])
    for i in eachrow(raw_data)
        num, letter = split(i.restrictions)
        num1, num2 = split(num, "-")
        password = lstrip(i.password)
        push!(data, [parse.(Int, [num1, num2])..., first(letter), password])
    end

    return data
end

# get valid count
function count_valid(data::DataFrame)
    i = 0
    
    for row in eachrow(data)
        letter_count = count(x -> x == row.letter, row.password)
        
        if row.num1 ≤ letter_count ≤ row.num2
            i += 1
        end
    end

    return i
end

println(count_valid(clean_data(rename!(DataFrame(readdlm(datafile, ':')), [:restrictions, :password]))))

#=
BenchmarkTools.Trial:
  memory estimate:  2.36 MiB
  allocs estimate:  66697
  --------------
  minimum time:     7.798 ms (0.00% GC)
  median time:      8.731 ms (0.00% GC)
  mean time:        9.293 ms (2.53% GC)
  maximum time:     16.071 ms (25.07% GC)
  --------------
  samples:          539
  evals/sample:     1
=#

function count_valid_corrected(data::DataFrame)
    i = 0

    for row in eachrow(data)
        if (row.password[row.num1] == row.letter) ⊻ (row.password[row.num2] == row.letter)
            i += 1
        end
    end

    return i
end

println(count_valid_corrected(clean_data(rename!(DataFrame(readdlm(datafile, ':')), [:restrictions, :password]))))

#=
BenchmarkTools.Trial:
  memory estimate:  2.11 MiB
  allocs estimate:  53354
  --------------
  minimum time:     6.707 ms (0.00% GC)
  median time:      7.422 ms (0.00% GC)
  mean time:        7.863 ms (2.77% GC)
  maximum time:     14.772 ms (0.00% GC)
  --------------
  samples:          636
  evals/sample:     1
=#
