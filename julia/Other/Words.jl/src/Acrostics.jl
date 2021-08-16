"""
Returns (true/false, character column)
"""
function acrostic(input::Vector{S1}, wordlist::Vector{S2}) where {S1 <: AbstractString, S2 <: AbstractString}
    @warn "This is a brute-force function, and will likely be very slow."
    # iterate over indices of 1:length of shortest word in input
    for i in 1:minimum(length(w) for w in input)
        potential_acrostic = ""
        # consrruct the potential abecedarius based on index
        for w in input
            w = lowercase(w)
            potential_acrostic *= w[1]
        end
    end
    
    
    # iterate over indices of 1:length of shortest word in input
    for i in 1:minimum(length(w) for w in input)
        potential_abecedarius = ""
        # consrruct the potential abecedarius based on index
        for w in input
            w = lowercase(w)
            potential_abecedarius *= w[i]
        end
        # check whether or not the potential abecedarius is in any part of the alphabet
        for j_start in 1:26
            for j_end in j_start:26
                alphabet_slice = alphabet[j_start:j_end]
                if potential_abecedarius == alphabet_slice
                    return (true, i, alphabet_slice, :left)
                end
            end
        end
    end
    
    # if we got here, no part of this is an abecedarius
    return (false, 0, "", :none)
    
    str_stipped = lowercase(_skipblanks(str))
    shortest_in_list = minimum(length(w) for w in wordlist)
    i = 0
    while true
        # if the length of the string is less than the number of words
        # multiplied by the shortest in the list, then there is no way
        # we can make your string.  Break
        if length(str) < (i * shortest_in_list)
            return false
        end
        # check every combination of 1, 2, 3, ... i words from the list
        for wᵢ in Base.Iterators.product([wordlist for _ in 1:i]...)
            this_sentence = join(wᵢ, " ")
            this_sentence_stripped = lowercase(_skipblanks(this_sentence))
            if areanagrams(str_stipped, this_sentence_stripped)
                return this_sentence
            end
        end
        # increment word counter
        i += 1
        # break if you have reached the maximum number of words in your lost
        if i > length(wordlist)
            return nothing
        end
    end
end
isacrostic(input::S1, wordlist::Vector{S2}) where {S1 <: AbstractString, S2 <: AbstractString} =
    isacrostic(split(input, ' '), wordlist)

"""
Returns (true/false, character column, portion of alphabet, right/left/none)
"""
function abecedarius(input::Vector{S}) where {S <: AbstractString}
    alphabet = join('a':'z')
    # iterate over indices of 1:length of shortest word in input
    for i in 1:minimum(length(w) for w in input)
        potential_abecedarius = ""
        # consrruct the potential abecedarius based on index
        for w in input
            w = lowercase(w)
            potential_abecedarius *= w[i]
        end
        # check whether or not the potential abecedarius is in any part of the alphabet
        for j_start in 1:26
            for j_end in j_start:26
                alphabet_slice = alphabet[j_start:j_end]
                if potential_abecedarius == alphabet_slice
                    return (true, i, alphabet_slice, :left)
                end
            end
        end
    end
    
    # do the same as above but for "right-aligned" text
    # iterate over indices of 1:length of shortest word in input
    for i in 1:minimum(length(w) for w in input)
        potential_abecedarius = ""
        # consrruct the potential abecedarius based on index
        for w in input
            w = lowercase(w)
            potential_abecedarius *= w[length(w) - i + 1]
        end
        # check whether or not the potential abecedarius is in any part of the alphabet
        for j_start in 1:26
            for j_end in j_start:26
                alphabet_slice = alphabet[j_start:j_end]
                if potential_abecedarius == alphabet_slice
                    return (true, i, alphabet_slice, :right)
                end
            end
        end
    end
    
    # if we got here, no part of this is an abecedarius
    return (false, 0, "", :none)
end

"""
Returns true/false depending on whether or not the input is an abecadarius, or alphabetical acrostic
"""
function isabecedarius(input::Vector{S}) where {S <: AbstractString}
    return first(abecedarius(input))
end

# parse strings by spliting on spaces
for f in (:abecedarius, :isabecedarius)
    @eval begin
        function $f(input::S) where {S <: AbstractString}
            return $f(split(input, ' '))
        end
    end
end

# for f in (:abecedarius, :isabecedarius)
#     @eval begin
#         function $f(input::S1, wordlist::Vector{S2}) where {S1 <: AbstractString, S2 <: AbstractString}
#             return $f(split(input, ' '), wordlist)
#         end
#     end
# end
