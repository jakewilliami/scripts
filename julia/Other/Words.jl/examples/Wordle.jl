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
    summed_freq::Int
    
    function FiveLetterWord(word::String, letters::NTuple{5, CharFrequency}, summed_freq::Int)
        @assert(sum(l.freq for l in letters) == summed_freq, "The summed frequency of each letters has to add up to the frequency values, summed, in the char frequencies")
        return new(word, letters, summed_freq)
    end
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
    
    Q = OrderedDict{Char, CharFrequency}[sort(D[i], byvalue = true, by = cf -> cf.freq, rev = true) for i in 1:5]
    n = minimum(length(d) for d in Q)  # last position might, for example, never contain a 'q', so need to account for this
    V = Vector{FiveLetterWord}(undef, n)
    for i in 1:n
        letters = ntuple(j -> first(iterate(Q[j], i)).second, 5)
        word = join(cf.c for cf in letters)
        summed_freq = sum(cf.freq for cf in letters)
        V[i] = FiveLetterWord(word, letters, summed_freq)
    end
    sort!(V, by = flw -> flw.summed_freq, rev = true)
    
    return V
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
function find_most_common_wordle(wordlist::Vector{String})
    V = construct_frequency_map(wordlist)
    
    top_count = 0
    candidates = FiveLetterWord[]
    while top_count <= length(V)
        # Check if all characters are unique and that the anagrams are a single word
        if isempty(candidates)
            top_count += 1
            candidates = previous_word_combinations(V, top_count)
        else
            word_data = popfirst!(candidates)
            word = word_data.word
            if allunique(word) && word ∈ WORDLIST
                return word_data.word, word_data.summed_freq
            end
        end
    end
    return nothing
end


"Returns a dataframe of most common letters in each position, and their frequency count; just for my own interest, not really any point in it"
function _make_naive_words_dataframe(wordlist::Vector{String})
    V = construct_frequency_map(FIVE_LETTER_WORDS)
    
    df = DataFrame(c1 = Char[], c1_freq = Int[], c2 = Char[], c2_freq = Int[], c3 = Char[], c3_freq = Int[], c4 = Char[], c4_freq = Int[], c5 = Char[], c5_freq = Int[], word_freq_sum = Int[])
    for i in 1:length(V)
        df_row = []
        freq_sum = 0
        for j in 1:5
            cf = V[i].letters[j]
            push!(df_row, cf.c, cf.freq)
            freq_sum += cf.freq
        end
        push!(df_row, freq_sum)
        push!(df, df_row)
    end
    return df
end


function main()
    df = _make_naive_words_dataframe(FIVE_LETTER_WORDS)  # TODO: incorporate anagrams into code
    word, freq = find_most_common_wordle(FIVE_LETTER_WORDS)
    
    println((word, freq))
end

main()
