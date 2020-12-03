function trees_encountered(data_path::String, vertical_component::Integer, horizontal_component::Integer)
    tree_counter, col_counter, row_counter = 0, 1, 1
    data = readlines(data_path)
    bottom_row = length(data)

    while row_counter < bottom_row
        row_counter += vertical_component
        col_counter += horizontal_component
        current_row = data[row_counter]

        if length(current_row) < col_counter
            data[row_counter:end] = data[row_counter:end].^2
            current_row = data[row_counter]
        end
        
        if current_row[col_counter] == '#'
            tree_counter += 1
        end
    end
    
    return tree_counter
end

trees_encountered("data3.txt", 1, 3)

#=
BenchmarkTools.Trial:
  memory estimate:  486.55 KiB
  allocs estimate:  1969
  --------------
  minimum time:     265.612 μs (0.00% GC)
  median time:      300.526 μs (0.00% GC)
  mean time:        317.878 μs (3.14% GC)
  maximum time:     1.910 ms (67.69% GC)
  --------------
  samples:          10000
  evals/sample:     1
=#

prod(trees_encountered("data3.txt", i, j) for (i, j) in [(1, 1), (1, 3), (1, 5), (1, 7), (2, 1)])

#=
BenchmarkTools.Trial:
  memory estimate:  2.70 MiB
  allocs estimate:  9280
  --------------
  minimum time:     1.611 ms (0.00% GC)
  median time:      1.768 ms (0.00% GC)
  mean time:        1.886 ms (3.10% GC)
  maximum time:     5.110 ms (0.00% GC)
  --------------
  samples:          2650
  evals/sample:     1
=#
