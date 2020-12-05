function bisect(x::UnitRange{T}) where T <: Integer
    lower, upper = getfield(x, :start), getfield(x, :stop)
    mid = lower + div(upper - lower, 2)
    
    return lower:mid, (mid + 1):upper
end

function find_number(str::String, lower::Int, upper::Int, str_lower::Int, str_upper::Int)
    current_range = lower:upper
    
    for i in str_lower:str_upper
        instruction = getindex(str, i)
        bottom, top = bisect(current_range)
    
        if instruction == 'F' || instruction == 'L' # F and L means to take the lower half
            upper = getfield(bottom, :stop)
        elseif instruction == 'B' || instruction == 'R' # B and R means to take the upper half
            lower = getfield(top, :start)
        end
    
        current_range = lower:upper
    end
    
    return getfield(current_range, :start)
end

function get_values(datafile::String, lower::Int, upper::Int, str_lower::Int, str_upper::Int)
    data = Vector{Int}()
    
    open(datafile) do io
        while ! eof(io)
            line = readline(io)
            push!(data, find_number(line, lower, upper, str_lower, str_upper))
        end
        
        return data
    end
end

# multiple dispatch on `get_values` for data as vector rather than file
function get_values(data::Vector{T}, lower::Int, upper::Int, str_lower::Int, str_upper::Int) where T <: AbstractString
    return Int[find_number(line, lower, upper, str_lower, str_upper) for line in data]
end

# specific functions for this task (i.e., there are 127 rows of seats, 7 seats in each row, and each line of data contains row info in indices 1--7 and seat info at indices 8--10)
function get_rows(data::Vector{T}) where T <: AbstractString
    return get_values(data, 0, 127, 1, 7)
end

function get_seats(data::Vector{T}) where T <: AbstractString
    return get_values(data, 0, 7, 8, 10)
end

function get_seat_ids(data::Vector{T}) where T <: AbstractString
    rows, seats = get_rows(data), get_seats(data)
    
    return rows .* 8 .+ seats
end

println(maximum(get_seat_ids(readlines("data5.txt"))))

#=
BenchmarkTools.Trial:
  memory estimate:  74.88 KiB
  allocs estimate:  1657
  --------------
  minimum time:     187.038 μs (0.00% GC)
  median time:      192.373 μs (0.00% GC)
  mean time:        217.239 μs (3.32% GC)
  maximum time:     6.013 ms (93.46% GC)
  --------------
  samples:          10000
  evals/sample:     1
=#

function ±(x::T, y::T) where T <: Number
    return x + y, x - y
end

function find_my_seat(data::Vector{T}) where T <: AbstractString
    seat_ids = get_seat_ids(data)
    
    return findfirst(seat -> seat ∉ seat_ids && all(i -> i ∈ seat_ids, seat ± 1), 0:maximum(seat_ids))
end

println(find_my_seat(readlines("data5.txt")))

#=
BenchmarkTools.Trial:
  memory estimate:  74.88 KiB
  allocs estimate:  1657
  --------------
  minimum time:     327.040 μs (0.00% GC)
  median time:      331.340 μs (0.00% GC)
  mean time:        355.110 μs (1.85% GC)
  maximum time:     6.157 ms (91.26% GC)
  --------------
  samples:          10000
  evals/sample:     1
=#
