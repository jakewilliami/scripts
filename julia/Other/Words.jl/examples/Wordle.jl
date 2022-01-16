include(joinpath(dirname(@__DIR__), "src", "Anagrams.jl")) # WORDLIST_AS_TREE, anagrams_resumable
# using .Words
using OrderedCollections # for dict sorting
using Combinatorics

const FIVE_LETTER_WORDS = String[lowercase(word) for word in filter(w -> length(w) == 5 && !any(ispunct(c) for c in w), WORDLIST)]

mutable struct CharFrequency
    c::Char
    freq::Int
    # pos::Int
end

struct FiveLetterWord
    word::String
    letters::NTuple{5, CharFrequency}
end

function construct_frequency_map(wordlist::Vector{String})
    @assert(all(length(w) == 5 for w in wordlist), "All words in the word list should be five letters long")
    D = [Dict{Char, CharFrequency}() for _ in 1:5]
    for word in wordlist
        for (i, c) in enumerate(word)
            if haskey(D[i], c)
                D[i][c].freq += 1
            else
                D[i][c] = CharFrequency(c, 0)
            end
        end
    end
    return D
end

# function find_most_common_word(wordlist::Vector{String})
    # D_unsorted = construct_frequency_map(wordlist)
    # D = OrderedDict{Char, CharFrequency}[sort(D_unsorted[i], byvalue = true, by = cf -> cf.freq, rev = true) for i in 1:5]
    # for i in 1:5
    #     O = D[i]
    #     println("$i:\t\'$(O[O.keys[1]].c)\'\t$(O[O.keys[1]].freq)")
    #     for j in 2:5
    #         println("  \t\'$(O[O.keys[j]].c)\'\t$(O[O.keys[j]].freq)")
    #     end
    # end
    # return nothing
    # counters = ones(Int, 5)
    # i = 1
    # io = IOBuffer()
    # while !any(k > length(wordlist) for k in counters)
    #     # check if the word is in the word list
    #     for j in 1:5
    #         # print(io, D[j][eachindex(D[j])[i]].first)
    #         # print(io, D[j][D[j].keys[i]])
    #         print(io, D[j].keys[counters[j]])
    #     end
    #     word = String(take!(io))
    #     @info("Trying \"$word\" with $counters")
    #     if word ∈ wordlist
    #         return word
    #     end
    #
    #     # if the word is not in the word list,
    #     # We need to decrement the least common word
    #     # but for now we will just take turns decrementing
    #     # a position until we find one that works
    #     counters[i] += 1
    #
    #     # check that we won't be out of range
    #     # if any(k > length(wordlist) for k in counters)
    #         # return nothing
    #     # end
    #
    #     i = i == 5 ? 1 : (i + 1) # reset to position 1 if we have reached the last position
    # end
# end

function previous_word_combinations(D::Vector{OrderedDict{Char, CharFrequency}}, n::Int)
    @assert(length(D) == 5, "We do not want to look for more than five positions")
    
    # Get the top n characters from each position
    # V = Vector{Vector{CharFrequency}}(undef, 5)
    M = Matrix{CharFrequency}(undef, n, 5)
    for i in 1:5
        for j in 1:n
            M[j, i] = first(iterate(D[i], j)).second
        end
        # V[i] = CharFrequency[iterate(D[i], j) for j in 1:n]
    end
    
    # Now we need to calculate the combinations of these
    # letters in these positions, but for all prior words
    nrows, ncols = size(M)
    M2 = Matrix{CharFrequency}(undef, nrows^ncols, ncols) # similar(M, nrows^ncols, ncols)
    for i in axes(M, 2) # 1:nrows
        M2[:, i] .= repeat(view(M, :, i), inner = nrows^(ncols - i), outer = nrows^(i - 1))
    end
    
    # Finally we need to construct a dictionary of
    # their summed score for each resulting word
    V = Pair{FiveLetterWord, Int}[FiveLetterWord(join(cf.c for cf in W), Tuple(W)) => sum(cf.freq for cf in W) for W in eachrow(M2)]
    sort!(V, by = last, rev = true)
    # println(V)
    
    return V
end

function find_most_common_anagram(wordlist::Vector{String})
    D_unsorted = construct_frequency_map(wordlist)
    D = OrderedDict{Char, CharFrequency}[sort(D_unsorted[i], byvalue = true, by = cf -> cf.freq, rev = true) for i in 1:5]
    
    # Base case: the top-most characters are words
    # word = join(D[j].keys[counters[j]] for j in 1:5)
    word = join(first(D[j]).second.c for j in 1:5)
    if allunique(word) #&& any(iszero(count(==(' '), w)) for w in anagrams(WORDLIST_AS_TREE, word))
        return word
    end
    
    counters = ones(Int, 5)
    # i = 1
    top_count = 0
    # local word::FiveLetterWord
    V = Pair{FiveLetterWord, Int}[]
    # io = IOBuffer()
    while all(top_count <= length(J) for J in D)
        # Check if all characters are unique and that the anagrams are a single word
        println("Trying with V length $(length(V)), top_count $top_count")
        if isempty(V)
            top_count += 1
            V = previous_word_combinations(D, top_count) # get the top five words
        else
            word = popfirst!(V).first.word
            if allunique(word) && word ∈ WORDLIST
                return word
            end
        end
    end
    # while all(k <= length(D[l]) for (l, k) in enumerate(counters))
    #     # Check if all characters are unique and that the anagrams are a single word
    #     word = join(D[j].keys[counters[j]] for j in 1:5)
    #     if allunique(word) && any(iszero(count(==(' '), w)) for w in anagrams(WORDLIST_AS_TREE, word))
    #         return word
    #     end
    #
    #     # If we got here, then the current word is not
    #     # a word with unique characters, nor an anagram.
    #     # We want to find the combination with the highest
    #     # combined frequency
    #     # k, old_sum = (0, 0)
    #     # for i in 1:5
    #     #     chars = CharFrequency[D[j][D[j].keys[counters[i == j ? i + 1 : i]]] for j in 1:5]
    #     #     if sum(cf.freq for cf in chars) > old_sum
    #     #         k = i
    #     #     end
    #     # end
    #     # maximum(1:5) do i
    #     #     chars = CharFrequency[D[j][counters[i == j ? i + 1 : i]] for j in 1:5]
    #     #     sum(cf.freq for cf in chars)
    #     # end
    #     # counters[k] += 1
    #
    #     if isempty(V)
    #         top_count += 1
    #         V = previous_word_combinations(D, top_count) # get the top five words
    #     else
    #
    #     end
    #
    #
    #     # if the word is not in the word list,
    #     # We need to decrement the least common word
    #     # but for now we will just take turns decrementing
    #     # a position until we find one that works
    #     # counters[i] += 1
    #
    #     # i = i == 5 ? 1 : (i + 1) # reset to position 1 if we have reached the last position
    # end
end

function main()
    # word = find_most_common_word(FIVE_LETTER_WORDS)
    word = find_most_common_anagram(FIVE_LETTER_WORDS)
    # D_unsorted = construct_frequency_map(FIVE_LETTER_WORDS)
    # D = OrderedDict{Char, CharFrequency}[sort(D_unsorted[i], byvalue = true, by = cf -> cf.freq, rev = true) for i in 1:5]
    # V = previous_word_combinations(D, 2)
    # println(V)
    # io = IOBuffer()
    # for i in 1:5
    #     print(io, first(D[i]).first)
    # end
    # word = String(take!(io))
    
    
    
    # println('"', word, '"')
    # a = 0
    # for w in anagrams(WORDLIST_AS_TREE, word)
    #     if iszero(count(==(' '), w)) && w != word
    #         a += 1
    #         println('\t', w)
    #     end
    # end
    # if iszero(a)
    #     println("\tNo valid anagrams found for this word")
    # end
    
    
    
    println(word)
end

main()
