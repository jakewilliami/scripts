function find_bag(
    dict::Dict,
    key::Union{String, SubString},
    search_value::Union{String, SubString}
    )
    
    inner_bags = dict[key]
    
    # bags = []
    # bags_added = []
    #
    # while true
    #     for outer_bag in keys(dict)
    #         if key in dict[outer_bag] && outer_bag ∉ bags
    #             push!(bags_added, outer_bag)
    #         end
    #     end
    #     if isempty(bags_added)
    #         break
    #     else
    #         push!(bags, bags_added)
    #         bags_added = []
    #     end
    # end

    
    if dict[key] isa AbstractArray
        if haskey(dict, key)
            if search_value ∈ inner_bags
                return true
            elseif search_value == key || "no other" ∈ inner_bags # technically we disqualify when search value is directly search key
                return false
            end
        end
    
        for v in inner_bags
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
  memory estimate:  197.71 MiB
  allocs estimate:  3803843
  --------------
  minimum time:     185.956 ms (4.24% GC)
  median time:      190.825 ms (5.28% GC)
  mean time:        190.982 ms (5.44% GC)
  maximum time:     199.302 ms (5.05% GC)
  --------------
  samples:          27
  evals/sample:     1
=#

function count_bags(dict::Dict, search_bag::Union{String, SubString})
    inner_most = Vector{Dict}()
    
    for contents in values(dict)
        if isempty(contents)
            push!(inner_most, contents)
        end
    end
    
    if search_bag ∈ inner_most
        return 0
    else
        num_bags = 0
        
        for bag in keys(dict[search_bag])
            num_bags += dict[search_bag][bag]
            num_bags += dict[search_bag][bag] * (count_bags(dict, bag))
        end
        
        return num_bags
    end
end

function count_bags_required(datafile::String, search_bag::String)
    babushka_bags = Dict{String, Union{String, Dict, Vector}}()

    open(datafile) do io
        while ! eof(io)
            line = readline(io)
            inner_dict = Dict{String, Int}()
            
            outer_bag, inner_bags = split(line, "contain")
            outer_bag = strip.(replace.(outer_bag, r"(\bbag\b)|(\bbags\b)" => ""))
            inner_bags = strip.(replace.(filter!(e -> e ≠ "", split(inner_bags, r"[,|.]")), r"(\bbag\b)|(\bbags\b)" => ""))
            inner_match = match.(r"(\d+)\s(.+)", inner_bags)
            inner_bags = all(isnothing.(inner_match)) ? inner_bags : getfield.(inner_match, :captures)
            
            if "no other" ∉ inner_bags
                for i in inner_bags
                    push!(inner_dict, last(i) => parse(Int, first(i)))
                end
            end

            push!(babushka_bags, outer_bag => inner_dict)
        end
    end
    
    return count_bags(babushka_bags, search_bag)
end

println(count_bags_required("data7.txt", "shiny gold"))
