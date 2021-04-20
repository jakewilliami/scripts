shortestPath = Pair{String, Float64}[
    "Te Aro Street" => 2.0,
    "Adam's Terrace" => 0.2,
    "Adam's Terrace" => 0.1,
    "Adam's Terrace" => 0.3,
    "Fairlie Terrace" => 1.2
]

function displayPath(path::Vector{Pair{AbstractString, Number}})
    total_distance = 0.0
    road_length = 0.0
    temp_length = 0.0
    output_text = String[]

    # initialise hashmap
    collapsed_hashmap = Dict{String, Float64}()
    
    for i in 1:length(path)
        street_name, street_length = path[i]
        if haskey(collapsed_map, )
    end
end

println(displayPath(shortestPath))
