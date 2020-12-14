const datafile = "inputs/data12.txt"

function parse_input(datafile::String)
    instructions = Matrix{Union{Symbol, Int}}(undef, 0, 2)

    open(datafile) do io
        while ! eof(io)
            line = readline(io)
            action, value = match(r"(\w)(\d+)", line).captures
            action, value = Symbol(action), parse(Int, value)
            instructions = cat(instructions, [action value], dims = 1)
        end
    end

    return instructions
end

mutable struct Ship
    facing::Symbol
    pos::NTuple{4, Int}
    
    Ship() = new(:E, (0, 0, 0, 0)) # ship starts facing east
    Ship(facing::Symbol, pos::NTuple{4, Int}) = new(facing, pos)
end

function move(pos::NTuple{4, Int}, direction::Symbol, pos_shift::Int)
    cardinal_directions = Symbol[:N, :E, :S, :W]
    direction_idx = findfirst(e -> e == direction, cardinal_directions)
    opposite_idx = mod1(direction_idx + 2, 4)
    pos = collect(pos)
    
    # shifting given direction
    pos[direction_idx] = pos[direction_idx] + pos_shift
    
    # equalising antipodes
    antipode_view = view(pos, [direction_idx, opposite_idx])
    local_antipode_max_idx = argmax(antipode_view)
    antipode_max_idx = antipode_view.indices[1][local_antipode_max_idx]
    pos[antipode_max_idx] = abs(pos[direction_idx] - pos[opposite_idx])
    pos[mod1(antipode_max_idx + 2, 4)] = 0
    
    return Tuple(pos)
end

function move!(ship::Ship, direction::Symbol, pos_shift::Int)
    setfield!(ship, :pos, move(ship.pos, direction, pos_shift))
    return ship
end

function move!(ship::Ship, pos_shift::Int)
    setfield!(ship, :pos, move(ship.pos, ship.facing, pos_shift))
    return ship
end

function rotate(facing::Symbol, direction::Symbol, deg::Int)
    cardinal_directions = Symbol[:N, :E, :S, :W]
    current_idx = findfirst(e -> e == facing, cardinal_directions)
    idx_shift = fld(deg, 90) * ifelse(direction == :R, 1, -1)
    
    return cardinal_directions[mod1(current_idx + idx_shift, 4)]
end

function rotate!(ship::Ship, direction::Symbol, deg::Int)
    setfield!(ship, :facing, rotate(ship.facing, direction, deg))
    return ship
end

function manhattan_distance(instructions::Matrix{T}) where T
    ship = Ship()
    
    for (action, value) in eachrow(instructions)
        if action ∈ [:L, :R]
            rotate!(ship, action, value)
        elseif action ∈ [:N, :E, :S, :W]
            move!(ship, action, value)
        elseif action == :F
            move!(ship, value)
        end
    end
    
    return sum(abs.((0, 0, 0, 0) .- ship.pos))
end

println(manhattan_distance(parse_input(datafile)))
