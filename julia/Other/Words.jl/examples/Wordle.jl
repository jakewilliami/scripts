include(joinpath(dirname(@__DIR__), "src", "Anagrams.jl")) # WORDLIST_AS_TREE, anagrams_resumable
using OrderedCollections # for dict sorting
using Combinatorics
using DataFrames


const FIVE_LETTER_WORDS = String[lowercase(word) for word in filter(w -> length(w) == 5 && !any(ispunct(c) for c in w), WORDLIST)]
const WORDLIST_TREE = WORDLIST_AS_TREE_ALT
const TOP_N_WORDS = 5


const FiveLetterCharFrequencies = NTuple{5, OrderedDict{Char, Int}}


mutable struct CharFrequency
    c::Char
    freq::Int
end


struct FiveLetterWord
    word::String
    letters::NTuple{5, CharFrequency}
    summed_freq::Int
    
    function FiveLetterWord(word::String, letters::NTuple{5, CharFrequency}, summed_freq::Int)
        @assert(sum(l.freq for l in letters) == summed_freq, "The summed frequency of each letters has to add up to the frequency values, summed, in the char frequencies")
        return new(word, letters, summed_freq)
    end
end


"Finds the most common characters for each position of a five letter word; returns a `Vector{FiveLetterWord}`, as well as a `NTuple{5, OrderedDict{Char, Int}}`"
function construct_frequency_map(wordlist::Vector{String})
    @assert(all(length(w) == 5 for w in wordlist), "All words in the word list should be five letters long")
    
    D = [Dict{Char, Int}(c => 0 for c in 'a':'z') for _ in 1:5]
    for word in wordlist
        for (i, c) in enumerate(word)
            D[i][c] += 1
        end
    end
    
    Q = Tuple(sort(D[i], byvalue = true, rev = true) for i in 1:5)::NTuple{5, OrderedDict{Char, Int}}
    n = length(Q[1]) # this should be 26 for each element in Q (26 letters of the alphabet)
    V = Vector{FiveLetterWord}(undef, n)
    for i in 1:n
        letters = ntuple(j -> CharFrequency(first(iterate(Q[j], i))...), 5)
        word = join(cf.c for cf in letters)
        summed_freq = sum(cf.freq for cf in letters)
        V[i] = FiveLetterWord(word, letters, summed_freq)
    end
    sort!(V, by = flw -> flw.summed_freq, rev = true)
    
    return V, Q
end


"Given the list of frequent characters in their positions, and a number `n`, this function will find all permutations of common words up to the number n in the list.  Difficult to explain, sorry"
function previous_word_combinations(words::Vector{FiveLetterWord}, n::Int)
    # Get the top n characters from each position
    M = Matrix{CharFrequency}(undef, n, 5)
    for i in 1:n
        M[i, :] .= words[i].letters
    end
    
    # Now we need to calculate the combinations of these
    # letters in these positions, but for all prior words
    nrows, ncols = size(M)
    M_permutations = Matrix{CharFrequency}(undef, nrows^ncols, ncols) # similar(M, nrows^ncols, ncols)
    for i in axes(M, 2) # 1:nrows
        M_permutations[:, i] .= repeat(view(M, :, i), inner = nrows^(ncols - i), outer = nrows^(i - 1))
    end
    
    # Finally we need to construct a dictionary of
    # their summed score for each resulting word
    V = Vector{FiveLetterWord}(undef, size(M_permutations, 1))
    for (i, W) in enumerate(eachrow(M_permutations))
        letters = Tuple(W)
        word = join(cf.c for cf in letters)
        summed_freq = sum(cf.freq for cf in letters)
        V[i] = FiveLetterWord(word, letters, summed_freq)
    end
    sort!(V, by = flw -> flw.summed_freq, rev = true)
    
    return V
end


"Given a word list, finds the most common word that is a word; returns a tuple of the word itself as a `String` and its summed frequency of letters as an `Int`"
function find_most_common_wordle(V::Vector{FiveLetterWord}, wordlist::Vector{String})
    top_count = 0
    candidates = FiveLetterWord[]
    while top_count <= length(V)
        # Check if all characters are unique and that the anagrams are a single word
        if isempty(candidates)
            top_count += TOP_N_WORDS
            candidates = previous_word_combinations(V, top_count)
        else
            word_data = popfirst!(candidates)
            word = word_data.word
            if allunique(word) && word ∈ wordlist
                return word, word_data.summed_freq
            end
        end
    end
    
    return nothing
end
find_most_common_wordle(W::Vector{String}) =
    find_most_common_wordle(first(construct_frequency_map(W)), W)

"Similar to `find_most_common_wordle`, but will try to find full-word acronyms as well, returniing a list of those acronyms (`Vector{String}`), and the word's score (`Int`)"
function find_most_common_wordle_anagram(V::Vector{FiveLetterWord})
    top_count = 0
    candidates = FiveLetterWord[]
    while top_count <= length(V)
        # Check if all characters are unique and that the anagrams are a single word
        if isempty(candidates)
            top_count += TOP_N_WORDS
            candidates = previous_word_combinations(V, top_count)
        else
            word_data = popfirst!(candidates)
            word = word_data.word
            A = String[w for w in anagrams(WORDLIST_TREE, word) if iszero(count(==(' '), w))]
            if allunique(word) && !isempty(A)
                return A, word_data.summed_freq
            end
        end
    end
    
    return nothing
end
find_most_common_wordle_anagram(W::Vector{String}) =
    find_most_common_wordle_anagram(first(construct_frequency_map(W)))


"Given a word and a word list, will determine your word's score from the sum of the positional characters' frequencies"
get_word_score(word::String, Q::FiveLetterCharFrequencies) = sum(Q[i][c] for (i, c) in enumerate(word))
get_word_score(word::String, W::Vector{String}) = get_word_score(last(construct_frequency_map(W)))


function main()
    # get the frequency information of five-letter words
    V, Q = construct_frequency_map(FIVE_LETTER_WORDS)
    
    # calculate the score of any given word
    score = get_word_score("seary", Q) # == 2163 # can also give it a word list
    
    # Find what we actually want to know
    res1 = find_most_common_wordle(V, FIVE_LETTER_WORDS)  # can also give it a word list
    res2 = find_most_common_wordle_anagram(V)  # can also give it a word list
    
    # Show results
    println("Best Wordle words to start with based on frequency analysis:")
    println("\tPosition-based: \t(frequency score $(res1[2])) \"$(res1[1])\"")
    println("\tAnagrams: \t\t(frequency score $(res2[2])) $(join((string("\"", w, "\"") for w in res2[1]), ", "))")
    # foreach(i -> println("\t\t\t\t\t\t\t\"$(res2[1][i])\""), 2:length(res2[1]))
end

main()

#=
$ julia --project examples/Wordle.jl
Best Wordle words to start with based on frequency analysis:
	Position-based: 	(frequency score 3447) "bares"
	Anagrams: 		(frequency score 3485) "basie"

$ julia --project examples/Wordle.jl # Alt/Big
Best Wordle words to start with based on frequency analysis:
	Position-based: 	(frequency score 5930) "sairy"
	Anagrams: 		(frequency score 6839) "sayer", "seary", "resay", "reasy"

$ julia --project examples/Wordle.jl # Tree Alt/Big
Best Wordle words to start with based on frequency analysis:
	Position-based: 	(frequency score 3447) "bares"
	Anagrams: 		(frequency score 3490) "beisa", "abies"
=#

# "Returns a dataframe of most common letters in each position, and their frequency count; just for my own interest, not really any point in it"
# function _make_naive_words_dataframe(wordlist::Vector{String})  # TODO: incorporate anagrams into this code
#     V, _ = construct_frequency_map(wordlist)
#
#     df = DataFrame(c1 = Char[], c1_freq = Int[], c2 = Char[], c2_freq = Int[], c3 = Char[], c3_freq = Int[], c4 = Char[], c4_freq = Int[], c5 = Char[], c5_freq = Int[], word_freq_sum = Int[])
#     for i in 1:length(V)
#         df_row = []
#         freq_sum = 0
#         for j in 1:5
#             cf = V[i].letters[j]
#             push!(df_row, cf.c, cf.freq)
#             freq_sum += cf.freq
#         end
#         push!(df_row, freq_sum)
#         push!(df, df_row)
#     end
#
#     return df
# end
