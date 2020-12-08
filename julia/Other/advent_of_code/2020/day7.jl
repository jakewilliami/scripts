function isbag_in_bag(
    dict::Dict,
    key::Union{String, SubString},
    search_value::Union{String, SubString}
    )
    #= Doov's
    bags = []
    bags_added = []
    
    while true
        for outer_bag in keys(dict)
            if key in dict[outer_bag] && outer_bag ∉ bags
                push!(bags_added, outer_bag)
            end
        end
        if isempty(bags_added)
            break
        else
            push!(bags, bags_added)
            bags_added = []
        end
    end
    =#

    inner_bags = dict[key]
    
    if inner_bags isa AbstractArray
        if haskey(dict, key)
            if search_value ∈ inner_bags
                return true
            elseif search_value == key || "no other" ∈ inner_bags
                return false
            end
        end
    
        for v in inner_bags
            if haskey(dict, v)
                if isbag_in_bag(dict, v, search_value)
                    return true
                end
            end
        end
    end
    
    return false
end

function count_bag_containers(datafile::String, search_bag::String)
    babushka_bags = Dict{String, Union{String, Dict, Vector}}()
    
    open(datafile) do io
        while ! eof(io)
            line = readline(io)
            outer_bag, inner_bags = split(line, "contain")
            outer_bag = strip.(replace.(outer_bag, r"(\bbag\b)|(\bbags\b)" => ""))
            inner_bags = strip.(replace.(filter!(e -> e ≠ "", split(inner_bags, r"[,|.]")), r"(\bbag\b)|(\bbags\b)|\d" => ""))
            
            push!(babushka_bags, outer_bag => inner_bags)
        end
    end
    
    
    return sum([isbag_in_bag(babushka_bags, outer_bag, search_bag) for outer_bag in keys(babushka_bags)])
end

println(count_bag_containers("data7.txt", "shiny gold"))

#=
BenchmarkTools.Trial:
  memory estimate:  151.30 MiB
  allocs estimate:  2908237
  --------------
  minimum time:     179.104 ms (3.45% GC)
  median time:      189.062 ms (4.22% GC)
  mean time:        190.356 ms (4.44% GC)
  maximum time:     229.057 ms (3.69% GC)
  --------------
  samples:          27
  evals/sample:     1
=#

function count_bags_recursive(dict::Dict, search_bag::Union{String, SubString})
    inner_most = Dict{Union{String, SubString}, Union{Vector, Dict}}[contents for contents in values(dict) if isempty(contents)]

    if search_bag ∉ inner_most
        return reduce(+, [dict[search_bag][bag] * (count_bags_recursive(dict, bag) + 1) for bag in keys(dict[search_bag])], init = 0)
    else
        return 0
    end
end

function count_bags_required(datafile::String, search_bag::String)
    babushka_bags = Dict{String, Union{String, Dict, Vector}}()

    open(datafile) do io
        while ! eof(io)
            line = readline(io)

            outer_bag, inner_bags = split(line, "contain")
            outer_bag = strip.(replace.(outer_bag, r"(\bbag\b)|(\bbags\b)" => ""))
            inner_bags = strip.(replace.(filter!(e -> e ≠ "", split(inner_bags, r"[,|.]")), r"(\bbag\b)|(\bbags\b)" => ""))
            inner_match = match.(r"(\d+)\s(.+)", inner_bags)
            inner_bags = all(isnothing.(inner_match)) ? inner_bags : getfield.(inner_match, :captures)

            push!(babushka_bags, outer_bag => Dict{Union{String, SubString}, Int}(last(i) => parse(Int, first(i)) for i in inner_bags if "no other" ∉ inner_bags))
        end
    end

    return count_bags_recursive(babushka_bags, search_bag)
end

println(count_bags_required("data7.txt", "shiny gold"))

#=
BenchmarkTools.Trial:
  memory estimate:  4.86 MiB
  allocs estimate:  114871
  --------------
  minimum time:     9.895 ms (0.00% GC)
  median time:      12.261 ms (0.00% GC)
  mean time:        13.236 ms (3.35% GC)
  maximum time:     45.043 ms (0.00% GC)
  --------------
  samples:          378
  evals/sample:     1
=#
