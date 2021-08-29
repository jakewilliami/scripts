# NOTE
# THESE ALGORITHMS LOOK THROUGH EVERY COMBINATION OF WORDS IN THE WORDLIST
# THE OPTIMISED ALGORITHM IN `../Anagrams.jl` LOOKS FOR EVERY PERMUTATION OF THE SEARCH STRING
# IN GENERAL, THE OPTIMISED ALGORITHM HAS FEWER COMBINATIONS TO CHECK

using Combinatorics: combinations

"""
```julia
make_anagram_extended(str::AbstractString, wordlist::Vector{<:AbstractString}) -> Vector{<:AbstractString}
```

Find anagrams of `str` given a `wordlist`.

This method is possibly not optimised, and will search for every combination of words.  I.e., given wordlist `["a", "b", "c"]`, will check all of
```julia
["a", "b", "c", "aa", "ba", "ca", "ab", "bb", "cb", "ac", "bc", "cc", "aaa", "baa", "caa", "aba", "bba", "cba", "aca", "bca", "cca", "aab", "bab", "cab", "abb", "bbb", "cbb", "acb", "bcb", "ccb", "aac", "bac", "cac", "abc", "bbc", "cbc", "acc", "bcc", "ccc"]
```
"""
function make_anagram_extended(str::S1, wordlist::Vector{S2}) where {S1 <: AbstractString, S2 <: AbstractString}
    Logging.@warn "This is a brute-force function, and will likely be very slow."
    str_stipped = lowercase(_skipblanks(str))
    anagrams = String[]
    shortest_in_list = minimum(length(w) for w in wordlist)
    i = 0
    while true
        # if the length of the string is less than the number of words
        # multiplied by the shortest in the list, then there is no way
        # we can make your string.  Break
        if length(str) < (i * shortest_in_list)
            return nothing
        end
        # check every combination of 1, 2, 3, ... i words from the list
        for wᵢ in Base.Iterators.product([wordlist for _ in 1:i]...)
            this_sentence = join(wᵢ, " ")
            this_sentence_stripped = lowercase(_skipblanks(this_sentence))
            if areanagrams(str_stipped, this_sentence_stripped)
                push!(anagrams, this_sentence)
                println(this_sentence)
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

"""
```julia
make_anagram(str::AbstractString, wordlist::Vector{<:AbstractString}) -> Vector{<:AbstractString}
```

Find anagrams of `str` given a `wordlist`.

Given wordlist `["a", "b", "c"]`, will check all of
```julia
["a", "b", "c", "ab", "ac", "bc", "abc"]
```
Because we don't care about order; if we found that "ab" is an anagram of `str`, then of course "ba" would be too—we don't need to check it again.
"""
function make_anagram(str::S1, wordlist::Vector{S2}) where {S1 <: AbstractString, S2 <: AbstractString}
    Logging.@warn "This is a brute-force function, and will likely be very slow."
    str_stripped = lowercase(_skipblanks(str))
    anagrams = String[]
    shortest_in_list = minimum(length(w) for w in wordlist)
    str_len = length(str)
    for wᵢ in combinations(wordlist)
        # if the length of the string is less than the number of words
        # multiplied by the shortest in the list, then there is no way
        # we can make your string.  Break
        if str_len < (length(wᵢ) * shortest_in_list)
            return nothing
        end
        if sum(length, wᵢ) > str_len
            continue
        end
        this_sentence = join(wᵢ, " ")
        this_sentence_stripped = lowercase(_skipblanks(this_sentence))
        if areanagrams(str_stripped, this_sentence_stripped)
            push!(anagrams, this_sentence)
            Logging.@info "Anagram found: \"$this_sentence\""
        end
    end
end
