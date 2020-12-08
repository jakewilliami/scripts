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

function find_bag_count(
    dict::Dict,
    key::Union{String, SubString},
    search_value::Union{String, SubString}
    )
    
    if haskey(dict, key) && haskey(dict, search_value)
        inner_dict = dict[key]
        
        if inner_dict isa Dict
            
            
            # if haskey(dict, key)
            #     if search_value ∈ inner_bags
            #         return true
            #     elseif search_value == key || "no other" ∈ inner_bags # technically we disqualify when search value is directly search key
            #         return false
            #     end
            # end
            #
            # for v in inner_bags
            #     if haskey(dict, v)
            #         if find_bag(dict, v, search_value)
            #             return true
            #         end
            #     end
            # end
            
            println("$key, $inner_dict")
            
            # if search_value == key
            #     for k in keys(inner_dict)
            #         return inner_dict[k] * find_bag_count(dict, k, search_value)
            #     end
            # elseif search_value ∈ keys(inner_dict)
            #     # println("we got in the keys")
            #     # for k in keys(inner_dict)
            #     #     return inner_dict[k] * find_bag_count(dict, k, search_value)
            #     # end
            #     return inner_dict[search_value] * sum(values(inner_dict))
            # elseif isempty(inner_dict)
            #     return 0
            # end
            
            
            # println(dict[search_value])
            if search_value ∈ keys(inner_dict)
                println("search value is in $(keys(inner_dict))")
                # println(key)
                return 0
                # return inner_dict[search_value] * sum(values(inner_dict))
            elseif key ∈ keys(dict[search_value])
                # multiplier = 1
                #
                # if haskey(inner_dict, search_value)
                #     multiplier = inner_dict[search_value]
                # end
                # println(dict[])
                return dict[search_value][key] * sum(values(inner_dict)) + dict[search_value][key]
            elseif search_value == key
                println("key is search value")
                return 0
            elseif isempty(inner_dict)
                println("inner dict is empty")
                return 0
            end
            
            # for (k, v) in inner_dict
            #
            # end
            # println((inner_dict))
            for v in keys(inner_dict)
                println(v)
                println(keys(dict[v]))
                if haskey(dict, v) #&& haskey(inner_dict, v)
                    # inner_multiplier = inner_dict[v]
                    # println(inner_multiplier)
                    🐢= find_bag_count(dict, v, search_value)
                    println(🐢)
                    if ! iszero(🐢)
                        # return 1
                        return 🐢 * dict[key][v] + 0 # sum(values(inner_dict))
                    end
                end
            end
            
            # println(inner_dict)
            # for (k, v) in inner_dict
            #     # println(v)
            #     if haskey(dict, k)
            #         🐢 = find_bag_count(dict, k, search_value) # turtles all the way down
            #         # println(🐢)
            #         if ! iszero(🐢)
            #             return 🐢
            #         end
            #     # if haskey(dict, v)
            #     #     if find_bag(dict, v, search_value)
            #     #         return true
            #     #     end
            #     # end
            #     end
            # # end
            # end
        end
    end
    
    return 0
end

# function find_bag_count(
#     dict::Dict,
#     key::Union{String, SubString}
#     # search_value::Union{String, SubString}
#     )
#
#     # search_dict = dict[search_value]
#     inner_dict = dict[key]
#
#     if inner_dict isa Dict
#         if isempty(inner_dict)
#             return 0
#         end
#
#         for (k, v) in inner_dict
#             return v * find_bag_count(dict, k)
#         end
#     end
#
#     return 0
# end

function count_bags(dict, search_bag)
    println(search_bag)
    inner_most = Vector{Dict}()
    for contents in values(dict)
        if isempty(contents)
            push!(inner_most, contents)
        end
    end
    
    if search_bag ∈ inner_most
        return 0
    # end
    # if (search_bag == "faded blue" || search_bag == "dotted black")
    #     return 0
    else
        num_bags = 0
        for bag in keys(dict[search_bag])
            println(dict[search_bag][bag])
            num_bags += dict[search_bag][bag]
            num_bags += dict[search_bag][bag] * (count_bags(dict, bag))
            # num_bags += sum(values(dict[search_bag])) * count_bags(dict, bag)
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
            
            # println(inner_bags)
            # nbags = 0
            # key = "no other"
            if "no other" ∉ inner_bags
                for i in inner_bags
                    # println(i)
                    nbags = parse(Int, first(i))
                    key = last(i)
                    # nbags = 0
                    #
                    # if length(i) > 1
                    #     nbags = parse(Int, first(i))
                    # end
                    
                    push!(inner_dict, last(i) => parse(Int, first(i)))
                end
                # println(inner_bags)
            end
            # println("$outer_bag contains $inner_dict")

            push!(babushka_bags, outer_bag => inner_dict)
        end
    end
    
    # [println("$outer_bag => $inner_bags") for (outer_bag, inner_bags) in babushka_bags]; println()
    # run(`cat test.txt`)
    
    # println(); println(babushka_bags)
    
    # println(); println([find_bag_count(babushka_bags, outer_bag, search_bag) for outer_bag in keys(babushka_bags)])

    # return sum([find_bag_count(babushka_bags, outer_bag, search_bag) for outer_bag in keys(babushka_bags)]) # add one for search_bag itself
    # return babushka_bags
    
    return count_bags(babushka_bags, search_bag)
end

# println(count_bags_required("data7.txt", "shiny gold"))
