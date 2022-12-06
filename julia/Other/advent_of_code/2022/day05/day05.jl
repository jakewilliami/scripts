# Parse input

const Crate = Char
const CrateState = Vector{Vector{Crate}}

struct Instruction
    n::Int
    src::Int
    dest::Int
end

INIT_CRATE_STATE_REGEXP = r"\s*\[([a-zA-Z]+)\]\s*"
INSTRUCTION_REGEXP = r"move (\d+) from (\d+) to (\d+)"

function parse_input(data_file::String)
    data_raw = read(data_file, String)
    A, B = split(data_raw, "\n\n")

    # Parse initial state
    col_width = 4
    line_len = findfirst('\n', A)
    n_stacks = cld(line_len - 1, col_width)
    init_state = Vector{Char}[Char[] for _ in 1:n_stacks]
    for a in split(A, "\n")
        for i in 1:n_stacks
            rₛ = (i - 1)*col_width + 1
            rₑ = i*col_width - 1
            b = a[rₛ:rₑ]
            m = match(INIT_CRATE_STATE_REGEXP, b)
            isnothing(m) && continue
            b = only(m.captures)
            push!(init_state[i], only(b))
        end
    end

    # Parse instructions
    instructions = Instruction[]
    for b in split(B, "\n")
        isempty(strip(b)) && continue
        m = match(INSTRUCTION_REGEXP, b)
        n, src, dest = m.captures
        i = Instruction(parse(Int, n), parse(Int, src), parse(Int, dest))
        push!(instructions, i)
    end

    return init_state, instructions
end


# Part 1

function _cratemover_core(init_state::CrateState, instructions::Vector{Instruction}, f::Function = identity)
    state = deepcopy(init_state)
    for inst in instructions
        a = splice!(state[inst.src], 1:inst.n)
        prepend!(state[inst.dest], f(a))
    end
    return state
end

cratemover_9000(init_state::CrateState, instructions::Vector{Instruction}) =
    _cratemover_core(init_state, instructions, reverse)

read_top_crates(state::CrateState) = join(first(c) for c in state)

function part1(init_state::CrateState, instructions::Vector{Instruction})
    new_state = cratemover_9000(init_state, instructions)
    return read_top_crates(new_state)
end


# Part 2

cratemover_9001(init_state::CrateState, instructions::Vector{Instruction}) =
    _cratemover_core(init_state, instructions)

function part2(init_state::CrateState, instructions::Vector{Instruction})
    new_state = cratemover_9001(init_state, instructions)
    return read_top_crates(new_state)
end


# Main

function main()
    init_state, instructions = parse_input("data05.txt")

    # Part 1
    part1_solution = part1(init_state, instructions)
    @assert part1_solution == "FWSHSPJWM"
    println("Part 1: $part1_solution")

    # Part 2
    part2_solution = part2(init_state, instructions)
    @assert part2_solution == "PWPWHGFZS"
    println("Part 2: $part2_solution")
end

main()
