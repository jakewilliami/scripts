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

function inranges(A::Vector{T}, D::Vector{R}) where {T <: Number} where R
    return map(A -> any(R -> A ∈ R, Base.Iterators.flatten(D)), A)
end

function inranges(A::Vector{T}, D::Dict{R, S}) where {T <: Number} where {R, S}
    return map(A -> any(R -> A ∈ R, Base.Iterators.flatten(values(D))), A)
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
# println(parse_input("inputs/test.txt"))

#=

=#

function getindices(A::Vector{Vector{T}}, i::Int) where {T, N}
    return T[a[i] for a in A]
end

function part2(
    rules::Dict{String, Vector{UnitRange{Int}}},
    my_ticket::Vector{Int},
    nearby_tickets::Vector{Vector{Int}}
)

    filtered_tickets, field_indices = copy(nearby_tickets), Dict{String, Int}()

    for nearby_ticket in nearby_tickets
        in_values_bools = inranges(nearby_ticket, rules)
        I = findall(iszero, in_values_bools)
        isempty(I) && continue
        deleteat!(filtered_tickets, findfirst(e -> e == nearby_ticket, filtered_tickets))
    end
    
    # for field in rules
    for i in 1:length(first(filtered_tickets))
        for field in rules
        # for i in 1:length(first(filtered_tickets))
            field_name, R = field
            i ∈ values(field_indices) && break
            println(keys(field_indices))
            # field_name ∈ keys(field_indices) && break
            # println("checking the $i'th position of nearby tickets $field_name's ranges $R")
                
            if all(inranges(getindices(filtered_tickets, i), R)) && R ∉ values(field_indices) && field_name ∉ keys(field_indices)
                println("found")
                field_indices[field_name] = i
            end
            
            println(values(field_indices))
            # i ∈ values(field_indices) && continue
        end
    end
    
    println(length(field_indices))
    println(field_indices)
    # println(prod(Int[my_ticket[idx] for (name, idx) in field_indices]))
    return prod(Int[my_ticket[idx] for (name, idx) in field_indices if contains(name, "departure")])
end

# println(part2(parse_input("inputs/test2.txt")...))
println(part2(parse_input(datafile)...))
# println(part2(parse_input(datafile)...) > 465763613683) # we want this to be true

# have guessed: 465763613683
