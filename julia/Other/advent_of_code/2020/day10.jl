const datafile = "inputs/data10.txt"

function get_adaptors_and_differences(datafile::String)
    chosen_adaptors = Matrix{Int}(undef, 0, 2)

    joltages = parse.(Int, readlines(datafile))
    builtin, current_adaptor = maximum(joltages) + 3, 0
    
    while true
        current_options = filter(e -> e ≤ current_adaptor + 3, joltages)
        new_adaptor = minimum(current_options)
        difference = new_adaptor - current_adaptor
        current_adaptor = new_adaptor
        deleteat!(joltages, findfirst(e -> e == current_adaptor, joltages))
        chosen_adaptors = cat(chosen_adaptors, [new_adaptor difference], dims = 1)
        
        if current_adaptor == builtin - 3
            chosen_adaptors = cat(chosen_adaptors, [builtin 3], dims = 1)
            
            return chosen_adaptors
        end
    end
end

get_adaptor_difference_tuple(datafile::String) = Tuple(count(==(i), get_adaptors_and_differences(datafile)[:, 2]) for i in (1, 3))
get_adaptor_difference_prod(datafile::String) = prod(count(==(i), get_adaptors_and_differences(datafile)[:, 2]) for i in (1, 3))

println(get_adaptor_difference_prod(datafile))
