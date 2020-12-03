using CSV, DataFrames

df = CSV.read("data1.csv", DataFrame)

function naive2(df)
    for i in eachrow(df)
        for j in eachrow(df)
            if i.n + j.n == 2020
                return i.n, j.n, i.n * j.n
            end
        end
    end
end

println(naive2(df))

#=
BenchmarkTools.Trial:
  memory estimate:  290.73 KiB
  allocs estimate:  18606
  --------------
  minimum time:     1.209 ms (0.00% GC)
  median time:      1.243 ms (0.00% GC)
  mean time:        1.314 ms (0.57% GC)
  maximum time:     7.708 ms (0.00% GC)
  --------------
  samples:          3794
  evals/sample:     1
=#

function naive3(df)
    for i in eachrow(df)
        for j in eachrow(df)
            for k in eachrow(df)
                if i.n + j.n + k.n == 2020
                    return i.n, j.n, k.n, i.n * j.n * k.n
                end
            end
        end
    end
end

println(naive3(df))

#=
BenchmarkTools.Trial:
  memory estimate:  289.40 MiB
  allocs estimate:  18965907
  --------------
  minimum time:     1.370 s (0.48% GC)
  median time:      1.400 s (0.53% GC)
  mean time:        1.416 s (0.55% GC)
  maximum time:     1.493 s (0.63% GC)
  --------------
  samples:          4
  evals/sample:     1
=#
