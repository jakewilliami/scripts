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
    waypoint_pos::NTuple{4, Int} # added for part 2
    
    Ship() = new(:E, (0, 0, 0, 0), (1, 10, 0, 0)) # ship starts facing east
    Ship(facing::Symbol, pos::NTuple{4, Int}, waypoint_pos::NTuple{4, Int}) = new(facing, pos, waypoint_pos)
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
    idx_shift = mod1(fld(deg, 90), 4) * ifelse(direction == :R, 1, -1)
    
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

#=
BenchmarkTools.Trial:
  memory estimate:  7.33 MiB
  allocs estimate:  52689
  --------------
  minimum time:     8.370 ms (0.00% GC)
  median time:      11.124 ms (0.00% GC)
  mean time:        11.641 ms (6.16% GC)
  maximum time:     21.652 ms (17.92% GC)
  --------------
  samples:          430
  evals/sample:     1
=#

function move_to_waypoint!(ship::Ship; n_times::Int = 1)
    pos = collect(ship.pos .+ ship.waypoint_pos .* n_times)
    vert_view, hor_view = view(pos, [1, 3]), view(pos, [2, 4])
    local_vert_max_idx, local_hor_max_idx = argmax(vert_view), argmax(hor_view)
    vert_max_idx, hor_max_idx = vert_view.indices[1][local_vert_max_idx], hor_view.indices[1][local_hor_max_idx]
    pos[vert_max_idx] = abs(pos[1] - pos[3])
    pos[hor_max_idx] = abs(pos[2] - pos[4])
    pos[mod1(vert_max_idx + 2, 4)], pos[mod1(hor_max_idx + 2, 4)] = 0, 0

    setfield!(ship, :pos, Tuple(pos))

    return ship
end

function move_waypoint!(ship::Ship, direction::Symbol, pos_shift::Int)
    setfield!(ship, :waypoint_pos, move(ship.waypoint_pos, direction, pos_shift))
    return ship
end

function rotate_waypoint!(ship::Ship, direction::Symbol, deg::Int)
    setfield!(ship, :waypoint_pos, Tuple(ship.waypoint_pos[mod1(i - (mod1(fld(deg, 90), 4) * ifelse(direction == :R, 1, -1)), 4)] for i in 1:4))
    return ship
end

function reset_waypoint!(ship::Ship)
    setfield!(ship, :waypoint_pos, ship.waypoint_pos)
    return ship
end

function manhattan_distance_again(instructions::Matrix{T}) where T
    ship = Ship()

    for (action, value) in eachrow(instructions)
        if action ∈ [:L, :R]
            rotate_waypoint!(ship, action, value)
        elseif action ∈ [:N, :E, :S, :W]
            move_waypoint!(ship, action, value)
        elseif action == :F
            move_to_waypoint!(ship, n_times = value)
            reset_waypoint!(ship)
        end
    end

    return sum(abs.((0, 0, 0, 0) .- ship.pos))
end

println(manhattan_distance_again(parse_input(datafile)))

#=
BenchmarkTools.Trial:
  memory estimate:  7.33 MiB
  allocs estimate:  52957
  --------------
  minimum time:     8.449 ms (0.00% GC)
  median time:      9.605 ms (0.00% GC)
  mean time:        10.706 ms (6.53% GC)
  maximum time:     21.025 ms (20.09% GC)
  --------------
  samples:          467
  evals/sample:     1
=#
