include(joinpath(dirname(@__DIR__), "src", "Anagrams.jl")) # WORDLIST_AS_TREE, anagrams_resumable
using OrderedCollections # for dict sorting
using Combinatorics
using DataFrames


const FIVE_LETTER_WORDS = String[lowercase(word) for word in filter(w -> length(w) == 5 && !any(ispunct(c) for c in w), WORDLIST)]


mutable struct CharFrequency
    c::Char
    freq::Int
end


struct FiveLetterWord
    word::String
    letters::NTuple{5, CharFrequency}
end


"Finds the most common characters for each position of a five letter word; returns an `OrderedDict{Char, CharFrequency}`"
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
    
    return OrderedDict{Char, CharFrequency}[sort(D[i], byvalue = true, by = cf -> cf.freq, rev = true) for i in 1:5]
end


"Given the list of frequent characters in their positions, and a number `n`, this function will find all permutations of common words up to the number n in the list.  Difficult to explain, sorry"
function previous_word_combinations(D::Vector{OrderedDict{Char, CharFrequency}}, n::Int)
    @assert(length(D) == 5, "We do not want to look for more than five positions")
    
    # Get the top n characters from each position
    M = Matrix{CharFrequency}(undef, n, 5)
    for i in 1:5
        for j in 1:n
            M[j, i] = first(iterate(D[i], j)).second
        end
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
    
    return V
end


"Given a word list, finds the most common word that is a word; returns a tuple of the word itself as a `String` and its summed frequency of letters as an `Int`"
function find_most_common_wordle(wordlist::Vector{String})
    D = construct_frequency_map(wordlist)
    
    top_count = 0
    V = Pair{FiveLetterWord, Int}[]
    while all(top_count <= length(J) for J in D)
        # Check if all characters are unique and that the anagrams are a single word
        if isempty(V)
            top_count += 1
            V = previous_word_combinations(D, top_count)
        else
            word_data = popfirst!(V)
            word = word_data.first.word
            if allunique(word) && word ∈ WORDLIST
                return word, word_data.second
            end
        end
    end
end


"Returns a dataframe of most common letters in each position, and their frequency count; just for my own interest"
function make_naive_words_list(wordlist::Vector{String})
    D = construct_frequency_map(FIVE_LETTER_WORDS)
    
    df = DataFrame(c1 = Char[], c1_freq = Int[], c2 = Char[], c2_freq = Int[], c3 = Char[], c3_freq = Int[], c4 = Char[], c4_freq = Int[], c5 = Char[], c5_freq = Int[], word_freq_sum = Int[])
    for i in 1:minimum(length(d) for d in D)
        df_row = []
        freq_sum = 0
        for j in 1:5
            cf = first(iterate(D[j], i)).second
            push!(df_row, cf.c, cf.freq)
            freq_sum += cf.freq
        end
        push!(df_row, freq_sum)
        push!(df, df_row)
    end
    return df
end


function main()
    df = make_naive_words_list(FIVE_LETTER_WORDS)  # TODO: incorporate anagrams into code
    word, freq = find_most_common_wordle(FIVE_LETTER_WORDS)
    
    println((word, freq))
end

main()
