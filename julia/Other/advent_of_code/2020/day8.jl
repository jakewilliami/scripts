using DelimitedFiles: readdlm

const datafile = "inputs/data8.txt"

function parse_input(datafile::String)
    instructions = Matrix{Union{Union{String, SubString}, Int}}(undef, 0, 2)
    
    open(datafile) do io
        while ! eof(io)
            line = readline(io)
            op, arg = readdlm(IOBuffer(line)) # alternatively; split(line) then parse arg as Int
            instructions = cat(instructions, [op arg], dims = 1)
        end
    end
    
    return instructions
end

function get_accumulator(instructions::Matrix)
    processed = Vector{Int}()
    row_idx, acc = 1, 0
    
    while row_idx ≤ size(instructions, 1)
        op, arg = instructions[row_idx, :]
        
        push!(processed, row_idx)
        
        if op == "acc"
            if row_idx + 1 ∈ processed
                return acc
            end
            acc += arg
            row_idx += 1
        elseif op == "jmp"
            if row_idx + arg ∈ processed
                return acc
            end
            row_idx += arg
        elseif op == "nop"
            if row_idx + 1 ∈ processed
                return acc
            end
            row_idx += 1
            continue
        end
    end
end

println(get_accumulator(parse_input(datafile)))

#=
BenchmarkTools.Trial:
  memory estimate:  29.85 MiB
  allocs estimate:  58606
  --------------
  minimum time:     37.364 ms (0.00% GC)
  median time:      48.198 ms (8.53% GC)
  mean time:        49.615 ms (6.95% GC)
  maximum time:     128.356 ms (3.09% GC)
  --------------
  samples:          101
  evals/sample:     1
=#

function ishalting(instructions::Matrix)
    processed = Vector{Int}()
    row_idx, acc = 1, 0

    while row_idx ≤ size(instructions, 1)
        op, arg = instructions[row_idx, :]
        push!(processed, row_idx)

        if op == "acc"
            acc += arg
            if row_idx + 1 ∈ processed
                return false, acc
            end

            row_idx += 1
        elseif op == "jmp"
            if row_idx + arg ∈ processed
                return false, acc
            end

            row_idx += arg
        elseif op == "nop"
            if row_idx + 1 ∈ processed
                return false, acc
            end

            row_idx += 1
            continue
        end
    end

    return true, acc
end

function get_corrected_accumulator(instructions::Matrix; line_number::Int = 1)
    acc = 0
    # [println(op, " <- ",  acc) for (op, acc) in eachrow(instructions)]

    for instruction in first.(Tuple.(findall(e -> e ∈ ["jmp", "nop"], instructions)))
        op, arg = instructions[instruction, :]
        instructions_test = copy(instructions)

        if op == "jmp"
            instructions_test[instruction, 1] = "nop"
        elseif op == "nop"
            instructions_test[instruction, 1] = "jmp"
        end

        maybe_halts = ishalting(instructions_test)
        # print(maybe_halts); println("\t", instructions[instruction, 1], " => ",instructions_test[instruction, 1], " at row ", instruction); println()
        if first(maybe_halts)
            return last(maybe_halts)
        end
    end
end

println(get_corrected_accumulator(parse_input(datafile)))

#=
BenchmarkTools.Trial:
  memory estimate:  47.14 MiB
  allocs estimate:  477655
  --------------
  minimum time:     82.221 ms (5.27% GC)
  median time:      91.534 ms (6.35% GC)
  mean time:        99.045 ms (6.52% GC)
  maximum time:     183.464 ms (6.98% GC)
  --------------
  samples:          51
  evals/sample:     1
=#
