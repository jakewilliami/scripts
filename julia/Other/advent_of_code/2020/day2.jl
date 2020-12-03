using DataFrames, DelimitedFiles, Debugger

raw_data = DataFrame(readdlm("data2.csv", ':'))
rename!(raw_data, [:restrictions, :password])

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

println(count_valid(clean_data(raw_data)))

#=
BenchmarkTools.Trial:
  memory estimate:  2.07 MiB
  allocs estimate:  59734
  --------------
  minimum time:     6.093 ms (0.00% GC)
  median time:      7.131 ms (0.00% GC)
  mean time:        7.603 ms (2.70% GC)
  maximum time:     15.452 ms (33.18% GC)
  --------------
  samples:          658
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

println(count_valid_corrected(clean_data(raw_data)))

#=
BenchmarkTools.Trial:
  memory estimate:  1.79 MiB
  allocs estimate:  44063
  --------------
  minimum time:     5.012 ms (0.00% GC)
  median time:      5.410 ms (0.00% GC)
  mean time:        5.852 ms (3.07% GC)
  maximum time:     15.922 ms (30.89% GC)
  --------------
  samples:          855
  evals/sample:     1
=#
