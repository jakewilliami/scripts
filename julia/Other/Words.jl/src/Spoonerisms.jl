## UNDER CONSTRUCTION, AS MORPHEMES ARE HARD

function isspoonerism(input::Vector{S}) where {S <: AbstractString}
    # check that there are no more than two words hidden in the elements of the vector
    length(input) == 2 || error("Spoonerisms only occur between two words, sorry!")
    for w in input
        if contains(strip(w), ' ')
            error("The input vector is not allowed, as spoonerisms cal only occur between two words, sorry!")
        end
    end
    
    for i in 1:minimum(w for w in input)
end

function isspoonerism(input::S) where {S <: AbstractString}
    input = strip(input)
    
    # check that input is value
    space_count = 0
    for c in input
        if c == ' '
            space_count += 1
        end
        if space_count > 1
            error("Spoonerisms only occur between two words, sorry!")
        end
    end
    
    return isspoonerism(split(input, ' '))
end

"The Lord is a loving shepard"
"The Lord is a shoving leopard"
