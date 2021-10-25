using DataStructures

Base.@kwdef struct SubRule
    i::Int = 0
    condition_indices::Vector{Tuple{Vararg{Int}}} = Tuple{Vararg{Int}}[]
end

Base.@kwdef mutable struct Rule
    i::Int = 0
    # relies_on::Vector{SubRule} = SubRule[]
    char_match::Union{Char, Nothing} = nothing
end

AbstractRule = Union{Rule, SubRule}

function parse_rules(rules_raw::Vector{String})
    rules = AbstractRule[]
    for rule_raw in rules_raw
        local rule::Rule
        idx_end_idx, rule_start_idx = findfirst(": ", rule_raw)
        rule_idx = parse(Int, SubString(rule_raw, 1, prevind(rule_raw, idx_end_idx)))
        rule_content = SubString(rule_raw, nextind(rule_raw, rule_start_idx))
        if contains(rule_content, '"')
            # then the rule is a direct rule, and we can push it directly
            @assert length(rule_content) == 3 "Malformed direct rule; matches should only be a single character"
            char_match = only(filter(!=('"'), rule_content))
            rule = Rule(rule_idx, char_match)
            push!(rules, rule)
        else
            condition_indices = Tuple{Vararg{Int}}[]
            condition_idx_tuples = split(rule_content, '|')
            for condition_idx_tuple in condition_idx_tuples
                condition_strs = split(condition_idx_tuple)
                condition_idx_tuple = Tuple(parse(Int, condition_str) for condition_str in condition_strs)
                push!(condition_indices, condition_idx_tuple)
            end
            sub_rule = SubRule(rule_idx, condition_indices)
            push!(rules, sub_rule)
        end
    end
    return rules
end

findrule(j::Int, rules::Vector{AbstractRule}) = findfirst(r -> r.i == j, rules)

function queue_rules(rules_original::Vector{AbstractRule})
    rule_queue = Queue{AbstractRule}()
    rules = deepcopy(rules_original)
    local rule::AbstractRule
    rule = deleteat!(rule, findrule(0, rules))
    # enqueue!(rule_queue, first_rule)
    while !isempty(rules)
        # if rule isa Rule
            # enqueue!()
        # else
    end
    return rules
end

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

# rules_raw, input_raw = split_input("inputs/test19b.txt")
# rules = parse_rules(rules_raw)
# rule_queue, queue_rules(rules)


#######################################

RuleDict = Dict{Int, Union{Vector{Vector{Int}}, AbstractString}}

function message_isvalid(s::String, seq::Vector{Int}, rules::RuleDict)
    if isempty(s) || isempty(seq)
        return isempty(s) && isempty(seq)
    end
    
    r = rules[seq[1]]
    if '"' ∈ r
        if contains(r, s[1])
            return message_isvalid(s[2:end], seq[2:end], rules) # strip the first character
        else
            return false # wrong first character
        end
    else
        return any(message_isvalid(s, vcat(t, seq[2:end]), rules) for t in r) # expand the first term
    end
end

function parse_rule(s::String)
    n, e = split(s, ": ")
    if !contains(e, '"')
        e = Vector{Int}[Int[parse(Int, r) for r in split(t)] for t in split(e, '|')]
    end
    return parse(Int, n), e
end

### Part One

part1(rules::RuleDict, messages::Vector{String}) =
    sum(message_isvalid(m, zeros(Int, 1), rules) for m in messages)
function part1(input_path::String)
    rules_raw, messages = split_input(input_path)
    rules = RuleDict(Pair(parse_rule(s)...) for s in rules_raw)
    return part1(rules, messages)
end

@assert part1("inputs/test19c.txt") == 2
@assert part1("inputs/test19d.txt") == 3
println("Part One: ", part1("inputs/data19.txt"))

function part2(input_path::String)
    rules_raw, messages = split_input(input_path)
    rules = RuleDict(Pair(parse_rule(s)...) for s in rules_raw)
    rules[8] = last(parse_rule("8: 42 | 42 8"))
    rules[11] = last(parse_rule("11: 42 31 | 42 11 31"))
    return part1(rules, messages)
end

@assert part2("inputs/test19d.txt") == 12
println("Part Two: ", part2("inputs/data19.txt"))
