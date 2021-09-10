### Structs and consts

struct CupConfig
    cups::Vector{Int}
end

### Parsing

parse_input(input_file::String) = 
    Int[parse(Int, i) for i in collect(strip(read(input_file, String)))]

### Part 1

function rotr!(A::Vector{T}, i::Int) where {T}
    rot_A = circshift(A, i)
    for i in 1:length(A)
        A[i] = rot_A[i]
    end
    return A
end
rotl!(A::Vector{T}, i::Int) where {T} = rotr!(A, -i)

function do_move!(cup_config::Vector{Int}, current_index::Int)
    cup_config_cpy = copy(cup_config)
    current_cup = cup_config[current_index]
    lowest_label, highest_label = extrema(cup_config)
    
    # The crab picks up the three cups that are immediately clockwise of the current cup. They are removed from the circle; cup spacing is adjusted as necessary to maintain the circle.
    # next_three = cup_config[(current_index + 1):(current_index + 3)]
    ncups = length(cup_config)
    next_three = Vector{Int}(undef, 3)
    next_index = mod1(current_index + 1, ncups)
    for i in 1:3
        next_index = mod1(current_index + 1, length(cup_config))
        next_three[i] = cup_config[next_index]
        deleteat!(cup_config, next_index)
    end
    
    # The crab selects a destination cup: the cup with a label equal to the current cup's label minus one. If this would select one of the cups that was just picked up, the crab will keep subtracting one until it finds a cup that wasn't just picked up. If at any point in this process the value goes below the lowest value on any cup's label, it wraps around to the highest value on any cup's label instead.
    
    destination_cup = current_cup - 1
    # while true
    # tries = []
    while destination_cup ∈ next_three || destination_cup ∉ cup_config
        destination_decr = destination_cup - 1
        destination_cup = destination_decr < lowest_label ? highest_label : destination_decr
        # push!(tries, destination_cup)
        if destination_cup ∉ next_three && destination_cup ∈ cup_config
            # @info destination_cup, destination_cup ∈ cup_config
            break
        end
    end
    # @info tries
    
    #=
    destination_cup = current_cup - 1
    while true
        destination_decr = destination_cup - 1
        destination_cup = destination_decr < lowest_label ? highest_label : destination_decr
        if destination_cup ∉ next_three && destination_cup ∈ cup_config
            break
        end
    end
    =#
    
    # The crab places the cups it just picked up so that they are immediately clockwise of the destination cup. They keep the same order as when they were picked up.
    # @info destination_cup
    destination_index = findfirst(==(destination_cup), cup_config)
    # insert_dest_index = mod1(destination_index + 1, ncups)
    # @info destination_index
    for i in 1:3
        # insert!(cup_config, insert_dest_index, next_three[3 - i + 1])
        # insert!(cup_config, mod1(destination_index + i + 1, length(cup_config)), next_three[3 - i + 1])
        
        # if destination_index > current_index
        insert!(cup_config, mod1(destination_index + i, ncups), next_three[i])
        # @info "$current_index => $i => $(mod1(destination_index + i, ncups))"
        # elseif destination_index < current_index
            # insert!()
        # else
            # error("unreachable")
        # end
        
        # insert!(cup_config, mod1(destination_index - i + 1, length(cup_config)), next_three[3 - i + 1])
        # insert!(cup_config, mod1(), next_three[])
    end
    if destination_index < mod1(current_index, ncups)
        rotl!(cup_config, 3)
        # rotl!(cup_config, fld1(ncups - current_index, ncups) * 3)
    # else
        # rotl!(cup_config, mod1(ncups - current_index, ncups))
    end
    # destination_index < current_index&&(cup_config = circshift(cup_config, -3))
    # insert!(cup_config, current_index + 1, destination_cup)
    # deleteat!(cup_config, i > current_index ? i + 1 : i)
    
    
    # The crab selects a new current cup: the cup which is immediately clockwise of the current cup.
    # This will happen in the next move
    return (cup_config_cpy, current_cup, next_three, destination_cup, cup_config)
end

function part1(input_file::String)
    cup_config = parse_input(input_file)
    i = 7
    for j in 1:(i - 1)
        do_move!(cup_config, j)
    end
    orig, curr, pickup, dest, changed = do_move!(cup_config, i)
    println("         -- move $i  --          ")
    println("Original:    $(replace(join(orig, ", "), string(curr) => "($curr)"))")
    println("Pickup:      $(join(pickup, ", "))")
    println("Destination: $dest")
    println("Modified:    $(join(changed, ", "))")
end

part1("inputs/test23.txt")


