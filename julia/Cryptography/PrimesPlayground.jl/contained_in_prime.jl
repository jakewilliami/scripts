using ProgressMeter

const LONGEST_PRIME_2018 = big(2)^82_589_933 - 1
const LONGEST_PRIME_2018_STR = string(LONGEST_PRIME_2018)

function number_of_combinations_not_in_p(n::Integer, p_str::String)
    all_combinations = Base.Iterators.product([0:9 for _ in 1:n]...)
    j = 0
    p = Progress(length(all_combinations), 1) # minimum update interval: 1 second
    for m in all_combinations
        if !occursin(join(m), p_str)
            j += 1
        end
        next!(p)
    end
    return j
end
number_of_combinations_not_in_p(n::Integer, p::Integer) = 
    number_of_combinations_not_in_p(n, string(p_str))

println(number_of_combinations_not_in_p(7, LONGEST_PRIME_2018_STR))
