const datafile = "inputs/data19.txt"

using DataStructures

### Helper structs/type

struct SubRule
    i::Int
    condition_indices::Vector{Tuple{Vararg{Int}}}
end

struct Rule
    i::Int
    char_match::Char
end

AbstractRule = Union{Rule, SubRule}

### Parse rules

function parse_rule_rhs(rule_idx::Int, rule_rhs_raw::S)::AbstractRule where {S <: AbstractString}
    @assert length(rule_rhs_raw) == 3 "Malformed direct rule; matches should only be a single character"
    char_match = only(filter(!=('"'), rule_rhs_raw))
    return Rule(rule_idx, char_match)
end

function parse_subrule_rhs(subrule_idx::Int, subrule_rhs_raw::S)::AbstractRule where {S <: AbstractString}
    condition_indices = Tuple{Vararg{Int}}[]
    condition_idx_tuples = split(subrule_rhs_raw, '|')
    for condition_idx_tuple in condition_idx_tuples
        condition_strs = split(condition_idx_tuple)
        condition_idx_tuple = Tuple(parse(Int, condition_str) for condition_str in condition_strs)
        push!(condition_indices, condition_idx_tuple)
    end
    return SubRule(subrule_idx, condition_indices)
end

function parse_rule(rule_raw::S) where {S <: AbstractString}
    idx_end_idx, rule_start_idx = findfirst(": ", rule_raw)
    rule_idx = parse(Int, SubString(rule_raw, 1, prevind(rule_raw, idx_end_idx)))
    rule_content = SubString(rule_raw, nextind(rule_raw, rule_start_idx))
    if contains(rule_content, '"')
        # then the rule is a direct rule, and we can push it directly
        return parse_rule_rhs(rule_idx, rule_content)
    else
        # then the rule is a subrule, which pertains to other abstract rules
        return parse_subrule_rhs(rule_idx, rule_content)
    end
    error("Unreachable")
end

parse_rules(rules_raw::Vector{String}) =
    AbstractRule[parse_rule(r) for r in rules_raw]

findrule_index(j::Int, rules::Vector{AbstractRule}) = findfirst(r -> r.i == j, rules)
function findrule(j::Int, rules::Vector{AbstractRule})
    i = findrule_index(j, rules)
    if isnothing(i)
        throw(error(BoundsError, ": Cannot find rule with index $i"))
    end
    return rules[i]
end

function message_isvalid(s::S, rules::Vector{AbstractRule}; stack::Vector{Int} = zeros(Int, 1)) where {S <: AbstractString}
    if isempty(s) || isempty(stack)
        return isempty(s) && isempty(stack)
    end

    r = findrule(first(stack), rules)
    if r isa Rule
        if r.char_match == first(s)
            return message_isvalid(SubString(s, nextind(s, 1)), rules, stack = stack[2:end]) # strip the first character
        else
            return false # wrong first character
        end
    elseif r isa SubRule
        return any(message_isvalid(s, rules, stack = pushfirst!(stack[2:end], t...)) for t in r.condition_indices) # expand the first term
    else
        error("Unreachable")
    end
    error("Unreachable")
end

### Parse input

function split_input(lines::Vector{String})
    rule_re = r"(\d+):\s(.*)"
    filter!(!isempty, lines)
    rules_raw = String[]
    i = 1
    while i <= length(lines) && !isnothing(match(rule_re, lines[i]))
        push!(rules_raw, lines[i])
        i += 1
    end
    input_raw = lines[i:end]
    return rules_raw, input_raw
end
split_input(input_path::String) = split_input(readlines(input_path))

### Part One

part1(rules::Vector{AbstractRule}, messages::Vector{String}) =
    sum(message_isvalid(m, rules) for m in messages)
function part1(input_path::String)
    rules_raw, messages = split_input(input_path)
    rules = parse_rules(rules_raw)
    return part1(rules, messages)
end

@assert part1("inputs/test19c.txt") == 2
@assert part1("inputs/test19d.txt") == 3
println("Part One: ", part1(datafile))

#=
julia> @benchmark part1($datafile)
BenchmarkTools.Trial:
  memory estimate:  14.83 MiB
  allocs estimate:  195927
  --------------
  minimum time:     21.685 ms (0.00% GC)
  median time:      26.248 ms (0.00% GC)
  mean time:        28.904 ms (4.10% GC)
  maximum time:     66.555 ms (5.33% GC)
  --------------
  samples:          173
  evals/sample:     1
=#

### Part Two

function part2(input_path::String)
    rules_raw, messages = split_input(input_path)
    rules = parse_rules(rules_raw)
    rules[findrule_index(8, rules)] = parse_subrule_rhs(8, "42 | 42 8")
    rules[findrule_index(11, rules)] = parse_subrule_rhs(11, "42 31 | 42 11 31")
    # After altering the required rules, the rest of the problem is the same as part 1
    return part1(rules, messages)
end

@assert part2("inputs/test19d.txt") == 12
println("Part Two: ", part2(datafile))

#=
julia> @benchmark part2($datafile)
BenchmarkTools.Trial:
  memory estimate:  52.69 MiB
  allocs estimate:  653404
  --------------
  minimum time:     78.754 ms (3.60% GC)
  median time:      97.748 ms (3.53% GC)
  mean time:        102.857 ms (4.16% GC)
  maximum time:     196.395 ms (2.78% GC)
  --------------
  samples:          49
  evals/sample:     1
=#
