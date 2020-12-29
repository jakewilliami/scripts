using DelimitedFiles: readdlm

const datafile = joinpath(@__DIR__, "inputs", "data16.txt")

function Base.parse(R::Type{UnitRange{T}}, S::AbstractString) where T <: Number
    a, b = tryparse.(T, match(r"(\d+).(\d+)", S).captures)
    return any(isnothing.((a, b))) ? nothing : a:b
end

function parse_input(datafile::String)
    rules, my_ticket, nearby_tickets = Dict{String, Vector{UnitRange{Int}}}(), Vector{Int}(), Vector{Vector{Int}}()
    data_idx_of_interest = 1
    
    open(datafile) do io
        while ! eof(io)
            line = readline(io)
            
            if isempty(line)
                data_idx_of_interest += 1 #% 3
                continue
            end

            if data_idx_of_interest == 1
                identifier, values = split(line, ": ")
                identifier = replace(identifier, " " => "_")
                string_ranges = split(values, " or ")
                ranges = parse.(UnitRange{Int}, string_ranges)
                rules[identifier] = ranges
            elseif data_idx_of_interest == 2 && ! contains(line, "your ticket:")
                my_ticket = vec(readdlm(IOBuffer(line), ',', Int))
            elseif data_idx_of_interest == 3 && ! contains(line, "nearby tickets:")
                push!(nearby_tickets, vec(readdlm(IOBuffer(line), ',', Int)))
            end
        end
    end
    
    return rules, my_ticket, nearby_tickets
end

function inranges(A::Vector{T}, B::Vector{R}) where {T, R}
    return map(a -> any(R -> a ∈ R, Iterators.flatten(B)), A)
end

function inranges(A::Vector{T}, D::Dict{R, S}) where {T, R, S}
    return map(a -> any(R -> a ∈ R, Iterators.flatten(values(D))), A)
end

function inranges(I::Base.ValueIterator{T}, R::Vector{S}) where {T, S}
    println("We need to ensure that none of the ranges contain any of the vectors' values")
    return map(r -> any(a -> a ∈ r, collect(I)), R)
end

function sum_invalid(
    rules::Dict{String, Vector{UnitRange{Int}}},
    my_ticket::Vector{Int},
    nearby_tickets::Vector{Vector{Int}}
)

    values = Vector{Int}()

    for nearby_ticket in nearby_tickets
        in_values_bools = inranges(nearby_ticket, rules)
        I = findall(iszero, in_values_bools)
        isempty(I) && continue
        push!(values, nearby_ticket[I]...)
    end
    
    return sum(values)
end

println(sum_invalid(parse_input(datafile)...))

#=
BenchmarkTools.Trial:
  memory estimate:  9.98 MiB
  allocs estimate:  12042
  --------------
  minimum time:     2.482 ms (0.00% GC)
  median time:      2.682 ms (0.00% GC)
  mean time:        3.604 ms (23.91% GC)
  maximum time:     13.140 ms (79.99% GC)
  --------------
  samples:          1387
  evals/sample:     1
=#

function getindices(A::Vector{Vector{T}}, i::Int) where {T, N}
    return T[a[i] for a in A]
end

function field_search(
    rules::Dict{String, Vector{UnitRange{Int}}},
    my_ticket::Vector{Int},
    nearby_tickets::Vector{Vector{Int}}
)

	filtered_tickets, field_indices, len = copy(nearby_tickets), Dict{String, Int}(), length(rules)

	# filter the good tickets
	for nearby_ticket in nearby_tickets
		in_values_bools = inranges(nearby_ticket, rules)
		I = findall(iszero, in_values_bools)
		isempty(I) && continue
		deleteat!(filtered_tickets, findfirst(e -> e == nearby_ticket, filtered_tickets))
	end

	positions = Vector{Int}[[e[i] for e in filtered_tickets] for i in 1:len]
	mapped = Dict{String, Int}()

	# map ticket values to field names
	while length(mapped) < len
		for (i, pos) in enumerate(positions)
			i ∈ values(mapped) && continue
			valid = Vector{Tuple{String, Int}}()

			for rule in rules
				field_name, R = rule
				field_name ∈ keys(mapped) && continue
				if all(inranges(getindices(filtered_tickets, i), R))
					push!(valid, (field_name, i))
				end
			end

			if isone(length(valid))
				i, rule = first(valid)
				mapped[i] = rule
			end
		end
	end

	# return product of relevant results
	return prod(Int[my_ticket[idx] for (name, idx) in mapped if contains(name, "departure")])
end

println(field_search(parse_input(datafile)...))

#=
BenchmarkTools.Trial:
  memory estimate:  13.62 MiB
  allocs estimate:  16260
  --------------
  minimum time:     71.510 ms (0.00% GC)
  median time:      75.602 ms (0.00% GC)
  mean time:        77.730 ms (1.30% GC)
  maximum time:     115.070 ms (0.00% GC)
  --------------
  samples:          65
  evals/sample:     1
=#
