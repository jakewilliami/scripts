function _partial_filters()

end

"""
    partial_filters(char_set, f::Function)

Given a character set and a function, .  The function should do something with the iterator and return a collection.
"""
function partial_filters(char_set, f::Function; n::Int = 1, c2::String = "")
    filters = String[]
    
    for c in char_set
        r = f("$c$c2*")
        if length(r) > 10
            # println("$(length(r)): \"$c$c2*\" needs further recursion")
            append!(filters, partial_filters(char_set, f, n = n + 1, c2 = "$c$c2"))
        else
            # println("$(length(r)): \"$c$c2*\" to filters")
            push!(filters, string(c))
        end
    end
    
    return filters
end


# Examples

hex_itr = Base.Iterators.flatten(('a':'f', '0':'9'))
filters = partial_filters(hex_itr, _ -> rand(rand(0:20)))
println(filters)
