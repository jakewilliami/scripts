function find_bag(dict::Dict, key::Union{String, SubString}, search_value::Union{String, SubString})
    processed = Vector{String}()
    
    if haskey(dict, key)
        if search_value ∈ dict[key]
            return true
        elseif search_value == key || "no other" ∈ dict[key] # technically we disqualify when search value is directly search key
            return false
        end
    end
    
    if dict[key] isa AbstractArray
        for v in dict[key]
            if haskey(dict, v)
                if find_bag(dict, v, search_value)
                    return true
                end
            end
        end
    end
    
    return false
end

function count_bag_containers(datafile::String, search_bag::String)
    babushka_bags = Dict{String, Union{String, Dict, Vector}}()
    deep_babushka_bags = Dict{String, Union{String, Dict, Vector}}()
    
    open(datafile) do io
        while ! eof(io)
            line = readline(io)
            outer_bag, inner_bags = split(line, "contain")
            outer_bag = strip.(replace.(outer_bag, r"(\bbag\b)|(\bbags\b)" => ""))
            inner_bags = strip.(replace.(filter!(e -> e ≠ "", split(inner_bags, r"[,|.]")), r"(\bbag\b)|(\bbags\b)|\d" => ""))
            
            push!(babushka_bags, outer_bag => inner_bags)
        end
    end
    
    return sum([find_bag(babushka_bags, outer_bag, search_bag) for outer_bag in keys(babushka_bags)])
end

println(count_bag_containers("data7.txt", "shiny gold"))

#=
BenchmarkTools.Trial:
  memory estimate:  211.97 MiB
  allocs estimate:  3990727
  --------------
  minimum time:     193.786 ms (4.62% GC)
  median time:      200.099 ms (6.39% GC)
  mean time:        199.906 ms (6.34% GC)
  maximum time:     207.407 ms (6.60% GC)
  --------------
  samples:          26
  evals/sample:     1
=#
