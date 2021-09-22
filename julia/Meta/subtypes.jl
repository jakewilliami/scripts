function find_supersupertype(t::T) where T
    upper_type = t
    while true
        this_supertype = supertype(upper_type)
        if this_supertype == Any
            break
        else
            upper_type = this_supertype
        end
    end
    return upper_type
end

function print_subtypes(io::IO, t::Type, level::Int; indent::Int = 4)
    level == 1 && println(io, t)
    for s in subtypes(t)
        println(io, " " ^ (level * indent), s)
        print_subtypes(io, s, level + 1, indent = indent)
    end
end


"Finds the supertype of a given type and prints all subtypes for that tree"
function print_types(io::IO, t::T) where T
    upper_type = find_supersupertype(t)
    print_subtypes(io, upper_type, 1)
end
print_types(t::T) where {T} = print_types(stdout, t)

print_types(UInt8)
using ColorTypes; print_types(RGB)
