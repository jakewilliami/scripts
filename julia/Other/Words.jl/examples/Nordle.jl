module Wordle


export CharFrequency, SixLetterWord, NLetterCharFrequencies
export SIX_LETTER_WORDS, COMMON_SIX_LETTER_WORDS_SORTED, COMMON_SIX_LETTER_WORDS_MAP
export get_word_score
export find_most_common_wordle, find_most_common_wordle, find_most_common_wordle_anagram


include(joinpath(dirname(@__DIR__), "src", "Anagrams.jl"))
using OrderedCollections  # for dict sorting
using SpelledOut  # For variable names

n_letter_words(n::Int) = 
    String[lowercase(word) for word in filter(w -> length(w) == 6 && !any(ispunct(c) for c in w), WORDLIST_SCRABBLE)]
n_letter_words_var_name(n::Int) = Symbol(upper(spelled_out(i)) * "_LETTER_WORDS")

const N_LETTER_WORDS = Vector{String}[n_letter_words(n) for n in unique(length(w) for w in WORDLIST_SCRABBLE)]
const WORDLIST_TREE = WORDLIST_AS_TREE_SCRABBLE
const TOP_N_WORDS = 5


"Simply an alias for a tuple containing a frequency map for characters in each position of an n-letter word."
const NLetterCharFrequencies{N} where {N} = NTuple{N, OrderedDict{Char, Int}}


struct CharFrequency
    c::Char
    freq::Int
    CharFrequency(c::Char, freq::Int) = new(islowercase(c) ? c : lowercase(c), freq)
end


struct NLetterWord{N}
    word::String
    letters::NTuple{N, CharFrequency}
    NLetterWord{N}(word::String, letters::NTuple{N, CharFrequency}) where {N} = 
        new(all(islowercase(c) for c in word) ? word : lowercase(word), letters)
end
NLetterWord(word::String, letters::NTuple{N, CharFrequency}) where {N} = NLetterWord{N}(word, letters)

Base.show(io::IO, flw::NLetterWord) = print(io, "flw", "\"", flw.word, "\"")


"""
```julia
get_word_score(flw::NLetterWord, Q::NLetterCharFrequencies) -> Float64
get_word_score(word::String, Q::NLetterCharFrequencies) -> Float64

get_word_score(flw::NLetterWord, V::Vector{NLetterWord}) -> Float64  # Acts the same as above, uses a list of `NLetterWord`s (also obtained from `Wordle._construct_frequency_map`).  NOTE: This assumes these six letter words are sorted so that the highest scoring words are at the top!
get_word_score(word::String, V::Vector{NLetterWord}) -> Float64  # WARN: This method is not supported as searching for each character's positional frequency from a list of `NLetterWord`s is inefficient without a frequency map.  Consider using method `get_word_score(word::String, Q::NLetterCharFrequencies)`, or defining this method yourself (hint: use something like `V[findfirst(flw -> flw.letters[i].c == c, V)].letters[i].freq`)

get_word_score(flw::NLetterWord, W::Vector{String}) -> Float  # Will generate the frequency map from a list of words `W`
# get_word_score(word::String, W::Vector{String}) -> Float64  # ibid.

get_word_score(flw::NLetterWord) -> Float64  # defaults to using the generated frequency map, `COMMON_SIX_LETTER_WORDS_MAP`
get_word_score(word::String) -> Float64  # ibid.
```
Given a word and a frequency map (see `Wordle._previous_word_combinations`), will determine your word's score from the average of the proportion of each character's top positional frequency.  Will return a value between 0 and 1, where 1 is a statistically perfect word, and 0 is statistically terrible.  This rounds to 3 decimal places.
"""
get_word_score(flw::NLetterWord, Q::NLetterCharFrequencies{N}) where {N} =
    round(sum(cf.freq / first(Q[i]).second for (i, cf) in enumerate(flw.letters)) / N, digits = 3)
get_word_score(word::String, Q::NLetterCharFrequencies{N}) where {N} =
    round(sum(Q[i][c] / first(Q[i]).second for (i, c) in enumerate(lowercase(word))) / N, digits = 3)
    
get_word_score(flw::NLetterWord, V::Vector{NLetterWord}) =
    round(sum(cf.freq / first(V).letters[i].freq for (i, cf) in enumerate(flw.letters)) / length(flw.word), digits = 3)
    
get_word_score(flw::NLetterWord, W::Vector{String}) =
    get_word_score(flw, last(_construct_frequency_map(W)))
get_word_score(word::String, W::Vector{String}) =
    get_word_score(word, last(_construct_frequency_map(W)))


"Finds the most common characters for each position of a six letter word; returns a `Vector{NLetterWord}`, as well as a `NTuple{5, OrderedDict{Char, Int}}`"
function _construct_frequency_map(wordlist::Vector{String})
    @assert(all(length(w) == 6 for w in wordlist), "All words in the word list should be six letters long")
    
    D = [Dict{Char, Int}(c => 0 for c in 'a':'z') for _ in 1:6]
    for word in wordlist
        for (i, c) in enumerate(word)
            D[i][c] += 1
        end
    end
    
    Q = Tuple(sort(D[i], byvalue = true, rev = true) for i in 1:6)::NLetterCharFrequencies
    n = length(Q[1]) # this should be 26 for each element in Q (26 letters of the alphabet)
    V = Vector{NLetterWord}(undef, n)
    for i in 1:n
        letters = ntuple(j -> CharFrequency(first(iterate(Q[j], i))...), 6)
        word = join(cf.c for cf in letters)
        V[i] = NLetterWord(word, letters)
    end
    sort!(V, by = flw -> get_word_score(flw, Q), rev = true)
    
    return V, Q
end


const (COMMON_SIX_LETTER_WORDS_SORTED, COMMON_SIX_LETTER_WORDS_MAP) = _construct_frequency_map(SIX_LETTER_WORDS)


get_word_score(flw::NLetterWord) = get_word_score(flw, COMMON_SIX_LETTER_WORDS_MAP)
get_word_score(word::String) = get_word_score(word, COMMON_SIX_LETTER_WORDS_MAP)


"Given the list of frequent characters in their positions, and a number `n`, this function will find all permutations of common words up to the number n in the list.  Difficult to explain, sorry"
function _previous_word_combinations(words::Vector{NLetterWord}, n::Int)
    if n > length(words)
        error("n must be ≤ length(words) when using `_previous_word_combinations`")
    end
    
    # Get the top n characters from each position
    M = Matrix{CharFrequency}(undef, n, 6)
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
    V = Vector{NLetterWord}(undef, size(M_permutations, 1))
    for (i, W) in enumerate(eachrow(M_permutations))
        letters = Tuple(W)
        word = join(cf.c for cf in letters)
        V[i] = NLetterWord(word, letters)
    end
    sort!(V, by = flw -> get_word_score(flw, words), rev = true)
    
    return V
end


"""
```julia
find_most_common_wordle(V::Vector{NLetterWord}, wordlist::Vector{String}; ignore::Vector{Char} = Char[]) -> NLetterWord  # if you give it characters in the `ignore` keyword argument, it will look for words not including those characters
find_most_common_wordle(W::Vector{String}; default::Bool = true, ignore::Vector{Char} = Char[]) -> NLetterWord  # If `default`, will use the pre-generated (default) frequency list; otherwise will generate the list based on your word list
find_most_common_wordle(; ignore::Vector{Char} = Char[]) -> NLetterWord  # Uses default/pre-generated information to generate the best word
```
Given a word list, finds the most common word that is a word; returns a tuple of the word itself as a `NLetterWord`
"""
function find_most_common_wordle(V::Vector{NLetterWord}, wordlist::Vector{String}; ignore::Vector{Char} = Char[])
    chars_to_ignore = !isempty(ignore)
    top_count = 0
    candidates = NLetterWord[]
    while top_count <= length(V)
        # Check if all characters are unique and that the anagrams are a single word
        if isempty(candidates)
            top_count += TOP_N_WORDS
            candidates = _previous_word_combinations(V, top_count)
        else
            word_data = popfirst!(candidates)
            word = word_data.word
            if allunique(word) && word ∈ wordlist
                if chars_to_ignore
                    all(c ∉ ignore for c in word) || @goto did_not_pass_ignore
                end
                return word_data
                @label did_not_pass_ignore
            end
        end
    end
    
    return nothing
end
find_most_common_wordle(W::Vector{String}; default::Bool = true, ignore::Vector{Char} = Char[]) =
    find_most_common_wordle(default ? COMMON_SIX_LETTER_WORDS_SORTED : first(_construct_frequency_map(W)), W; ignore = ignore)
find_most_common_wordle(; ignore::Vector{Char} = Char[]) =
    find_most_common_wordle(SIX_LETTER_WORDS; default = true, ignore = ignore)


"""
```julia
find_most_common_wordle_anagram(V::Vector{NLetterWord}; ignore::Vector{Char} = Char[]) -> Vector{NLetterWord}  # if you give it characters in the `ignore` keyword argument, it will look for words not including those characters
find_most_common_wordle_anagram(W::Vector{String}; default::Bool = true, ignore::Vector{Char} = Char[]) -> Vector{NLetterWord}  # If `default`, will use the pre-generated (default) frequency list; otherwise will generate the list based on your word list
find_most_common_wordle_anagram(; ignore::Vector{Char} = Char[]) -> Vector{NLetterWord}  # Uses default/pre-generated information to generate the best word
```
Similar to `find_most_common_wordle`, but will try to find full-word acronyms as well, returning a list of these words as a `Vector{NLetterWord}`
"""
function find_most_common_wordle_anagram(V::Vector{NLetterWord}; ignore::Vector{Char} = Char[])
    chars_to_ignore = !isempty(ignore)
    top_count = 0
    candidates = NLetterWord[]
    while top_count <= length(V)
        # Check if all characters are unique and that the anagrams are a single word
        if isempty(candidates)
            top_count += TOP_N_WORDS
            candidates = _previous_word_combinations(V, top_count)
        else
            word_data = popfirst!(candidates)
            word = word_data.word
            A = String[w for w in anagrams(WORDLIST_TREE, word) if iszero(count(==(' '), w))]
            if allunique(word) && !isempty(A)
                if chars_to_ignore
                    all(c ∉ ignore for c in word) || @goto did_not_pass_ignore
                end
                anagram_data = Vector{NLetterWord}(undef, length(A))
                for (i, w) in enumerate(A)
                    letters = Tuple(CharFrequency(c, V[findfirst(flw -> flw.letters[j].c == c, V)].letters[j].freq) for (j, c) in enumerate(w))
                    anagram_data[i] = NLetterWord(w, letters)
                end
                return anagram_data
                @label did_not_pass_ignore
            end
        end
    end
    
    return nothing
end
find_most_common_wordle_anagram(W::Vector{String}; default::Bool = true, ignore::Vector{Char} = Char[]) =
    find_most_common_wordle_anagram(default ? COMMON_SIX_LETTER_WORDS_SORTED : first(_construct_frequency_map(W)); ignore = ignore)
find_most_common_wordle_anagram(; ignore::Vector{Char} = Char[]) = find_most_common_wordle_anagram(SIX_LETTER_WORDS; default = true, ignore = ignore)


"""
```julia
find_most_common_wordles(V::Vector{NLetterWord}, wordlist::Vector{String}, n::Int; ignore::Vector{Char} = Char[]) -> NLetterWord  # if you give it characters in the `ignore` keyword argument, it will look for words not including those characters
find_most_common_wordles(W::Vector{String}, n::Int; default::Bool = true, ignore::Vector{Char} = Char[]) -> NLetterWord  # If `default`, will use the pre-generated (default) frequency list; otherwise will generate the list based on your word list
find_most_common_wordles(n::Int; ignore::Vector{Char} = Char[]) -> NLetterWord  # Uses default/pre-generated information to generate the best word
```
Similar to `find_most_common_wordle`, except it will return a list of `n` best wordles (`Vector{NLetterWord}`).
"""
function find_most_common_wordles(V::Vector{NLetterWord}, wordlist::Vector{String}, n::Int; ignore::Vector{Char} = Char[])
    chars_to_ignore = !isempty(ignore)
    top_count = 0
    candidates = NLetterWord[]
    words = Vector{NLetterWord}(undef, n)
    i = 1
    while top_count <= length(V)
        # Check if all characters are unique and that the anagrams are a single word
        if isempty(candidates)
            top_count += TOP_N_WORDS
            candidates = _previous_word_combinations(V, top_count)
        else
            word_data = popfirst!(candidates)
            word = word_data.word
            if allunique(word) && word ∈ wordlist
                if chars_to_ignore
                    all(c ∉ ignore for c in word) || @goto did_not_pass_ignore
                end
                words[i] = word_data
                i += 1
                if i > n
                    return words
                end
                @label did_not_pass_ignore
            end
        end
    end
    
    return nothing
end
find_most_common_wordles(W::Vector{String}, n::Int; default::Bool = true, ignore::Vector{Char} = Char[]) =
    find_most_common_wordles(default ? COMMON_SIX_LETTER_WORDS_SORTED : first(_construct_frequency_map(W)), W, n; ignore = ignore)
find_most_common_wordles(n::Int; ignore::Vector{Char} = Char[]) =
    find_most_common_wordles(SIX_LETTER_WORDS, n; default = true, ignore = ignore)





using DataFrames
"Returns a dataframe of most common letters in each position, and their frequency count.  This is a function just for my own interest; not really any point in it"
function _make_naive_words_dataframe(wordlist::Vector{String})  # TODO: incorporate anagrams into this code
    V, Q = _construct_frequency_map(wordlist)

    df = DataFrame(c1 = Char[], c1_freq = Int[], c2 = Char[], c2_freq = Int[], c3 = Char[], c3_freq = Int[], c4 = Char[], c4_freq = Int[], c5 = Char[], c5_freq = Int[], c6 = Char[], c6_freq = Int[], word_score = Float64[])
    for i in 1:length(V)
        df_row = []
        for j in 1:6
            cf = V[i].letters[j]
            push!(df_row, cf.c, cf.freq)
        end
        push!(df_row, get_word_score(V[i], Q))
        push!(df, df_row)
    end

    return df
end


end # end module


using .Wordle


function main()
    # calculate the score of any given word
    score = get_word_score("coiny")  # == 0.665
    
    # Find what we actually want to know
    flw_wordle = find_most_common_wordle()
    flws_anagram = find_most_common_wordle_anagram()
    
    # Show results
    println("Best Wordle words to start with based on frequency analysis of ", length(SIX_LETTER_WORDS), " words:")
    println("\tPosition-based: \t", "\"", flw_wordle.word, "\" (", get_word_score(flw_wordle), ")")
    println("\tAnagrams: \t\t", join((string("\"", w.word, "\" (", get_word_score(w.word), ")") for w in flws_anagram), ", "))
    
    flws = Wordle.find_most_common_wordles(20)
    for flw_wordle in flws
        println("\t\"", flw_wordle.word, "\" (", get_word_score(flw_wordle), ")")
    end
end

main()
