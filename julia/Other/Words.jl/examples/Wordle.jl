module Wordle


export CharFrequency, FiveLetterWord, FiveLetterCharFrequencies
export FIVE_LETTER_WORDS, COMMON_FIVE_LETTER_WORDS_SORTED, COMMON_FIVE_LETTER_WORDS_MAP
export get_word_score
export find_most_common_wordle, find_most_common_wordle, find_most_common_wordle_anagram


include(joinpath(dirname(@__DIR__), "src", "Anagrams.jl")) # WORDLIST_AS_TREE, anagrams_resumable
using OrderedCollections # for dict sorting


const FIVE_LETTER_WORDS = String[lowercase(word) for word in filter(w -> length(w) == 5 && !any(ispunct(c) for c in w), WORDLIST_SCRABBLE)]
const WORDLIST_TREE = WORDLIST_AS_TREE_SCRABBLE
const TOP_N_WORDS = 5


"Simply an alias for a tuple containing a frequency map for characters in each position of a five-letter word."
const FiveLetterCharFrequencies = NTuple{5, OrderedDict{Char, Int}}


struct CharFrequency
    c::Char
    freq::Int
    CharFrequency(c::Char, freq::Int) = new(islowercase(c) ? c : lowercase(c), freq)
end


struct FiveLetterWord
    word::String
    letters::NTuple{5, CharFrequency}
    FiveLetterWord(word::String, letters::NTuple{5, CharFrequency}) = 
        new(all(islowercase(c) for c in word) ? word : lowercase(word), letters)
end


Base.show(io::IO, flw::FiveLetterWord) = print(io, "flw", "\"", flw.word, "\"")


"""
```julia
get_word_score(flw::FiveLetterWord, Q::FiveLetterCharFrequencies) -> Float64
get_word_score(word::String, Q::FiveLetterCharFrequencies) -> Float64

get_word_score(flw::FiveLetterWord, V::Vector{FiveLetterWord}) -> Float64  # Acts the same as above, uses a list of `FiveLetterWord`s (also obtained from `Wordle._construct_frequency_map`).  NOTE: This assumes these five letter words are sorted so that the highest scoring words are at the top!
get_word_score(word::String, V::Vector{FiveLetterWord}) -> Float64  # WARN: This method is not supported as searching for each character's positional frequency from a list of `FiveLetterWord`s is inefficient without a frequency map.  Consider using method `get_word_score(word::String, Q::FiveLetterCharFrequencies)`, or defining this method yourself (hint: use something like `V[findfirst(flw -> flw.letters[i].c == c, V)].letters[i].freq`)

get_word_score(flw::FiveLetterWord, W::Vector{String}) -> Float  # Will generate the frequency map from a list of words `W`
# get_word_score(word::String, W::Vector{String}) -> Float64  # ibid.

get_word_score(flw::FiveLetterWord) -> Float64  # defaults to using the generated frequency map, `COMMON_FIVE_LETTER_WORDS_MAP`
get_word_score(word::String) -> Float64  # ibid.
```
Given a word and a frequency map (see `Wordle._previous_word_combinations`), will determine your word's score from the average of the proportion of each character's top positional frequency.  Will return a value between 0 and 1, where 1 is a statistically perfect word, and 0 is statistically terrible.  This rounds to 3 decimal places.
"""
get_word_score(flw::FiveLetterWord, Q::FiveLetterCharFrequencies) =
    round(sum(cf.freq / first(Q[i]).second for (i, cf) in enumerate(flw.letters)) / 5, digits = 3)
get_word_score(word::String, Q::FiveLetterCharFrequencies) =
    round(sum(Q[i][c] / first(Q[i]).second for (i, c) in enumerate(lowercase(word))) / 5, digits = 3)
    
get_word_score(flw::FiveLetterWord, V::Vector{FiveLetterWord}) =
    round(sum(cf.freq / first(V).letters[i].freq for (i, cf) in enumerate(flw.letters)) / 5, digits = 3)
    
get_word_score(flw::FiveLetterWord, W::Vector{String}) =
    get_word_score(flw, last(_construct_frequency_map(W)))
get_word_score(word::String, W::Vector{String}) =
    get_word_score(word, last(_construct_frequency_map(W)))


"Finds the most common characters for each position of a five letter word; returns a `Vector{FiveLetterWord}`, as well as a `NTuple{5, OrderedDict{Char, Int}}`"
function _construct_frequency_map(wordlist::Vector{String})
    @assert(all(length(w) == 5 for w in wordlist), "All words in the word list should be five letters long")
    
    D = [Dict{Char, Int}(c => 0 for c in 'a':'z') for _ in 1:5]
    for word in wordlist
        for (i, c) in enumerate(word)
            D[i][c] += 1
        end
    end
    
    Q = Tuple(sort(D[i], byvalue = true, rev = true) for i in 1:5)::FiveLetterCharFrequencies
    n = length(Q[1]) # this should be 26 for each element in Q (26 letters of the alphabet)
    V = Vector{FiveLetterWord}(undef, n)
    for i in 1:n
        letters = ntuple(j -> CharFrequency(first(iterate(Q[j], i))...), 5)
        word = join(cf.c for cf in letters)
        V[i] = FiveLetterWord(word, letters)
    end
    sort!(V, by = flw -> get_word_score(flw, Q), rev = true)
    
    return V, Q
end


const (COMMON_FIVE_LETTER_WORDS_SORTED, COMMON_FIVE_LETTER_WORDS_MAP) = _construct_frequency_map(FIVE_LETTER_WORDS)


get_word_score(flw::FiveLetterWord) = get_word_score(flw, COMMON_FIVE_LETTER_WORDS_MAP)
get_word_score(word::String) = get_word_score(word, COMMON_FIVE_LETTER_WORDS_MAP)


"Given the list of frequent characters in their positions, and a number `n`, this function will find all permutations of common words up to the number n in the list.  Difficult to explain, sorry"
function _previous_word_combinations(words::Vector{FiveLetterWord}, n::Int)
    if n > length(words)
        error("n must be ≤ length(words) when using `_previous_word_combinations`")
    end
    
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
        V[i] = FiveLetterWord(word, letters)
    end
    sort!(V, by = flw -> get_word_score(flw, words), rev = true)
    
    return V
end


"""
```julia
find_most_common_wordle(V::Vector{FiveLetterWord}, wordlist::Vector{String}; ignore::Vector{Char} = Char[]) -> FiveLetterWord  # if you give it characters in the `ignore` keyword argument, it will look for words not including those characters
find_most_common_wordle(W::Vector{String}; default::Bool = true, ignore::Vector{Char} = Char[]) -> FiveLetterWord  # If `default`, will use the pre-generated (default) frequency list; otherwise will generate the list based on your word list
find_most_common_wordle(; ignore::Vector{Char} = Char[]) -> FiveLetterWord  # Uses default/pre-generated information to generate the best word
```
Given a word list, finds the most common word that is a word; returns a tuple of the word itself as a `FiveLetterWord`
"""
function find_most_common_wordle(V::Vector{FiveLetterWord}, wordlist::Vector{String}; ignore::Vector{Char} = Char[])
    chars_to_ignore = !isempty(ignore)
    top_count = 0
    candidates = FiveLetterWord[]
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
    find_most_common_wordle(default ? COMMON_FIVE_LETTER_WORDS_SORTED : first(_construct_frequency_map(W)), W; ignore = ignore)
find_most_common_wordle(; ignore::Vector{Char} = Char[]) =
    find_most_common_wordle(FIVE_LETTER_WORDS; default = true, ignore = ignore)


"""
```julia
find_most_common_wordle_anagram(V::Vector{FiveLetterWord}; ignore::Vector{Char} = Char[]) -> Vector{FiveLetterWord}  # if you give it characters in the `ignore` keyword argument, it will look for words not including those characters
find_most_common_wordle_anagram(W::Vector{String}; default::Bool = true, ignore::Vector{Char} = Char[]) -> Vector{FiveLetterWord}  # If `default`, will use the pre-generated (default) frequency list; otherwise will generate the list based on your word list
find_most_common_wordle_anagram(; ignore::Vector{Char} = Char[]) -> Vector{FiveLetterWord}  # Uses default/pre-generated information to generate the best word
```
Similar to `find_most_common_wordle`, but will try to find full-word acronyms as well, returning a list of these words as a `Vector{FiveLetterWord}`
"""
function find_most_common_wordle_anagram(V::Vector{FiveLetterWord}; ignore::Vector{Char} = Char[])
    chars_to_ignore = !isempty(ignore)
    top_count = 0
    candidates = FiveLetterWord[]
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
                anagram_data = Vector{FiveLetterWord}(undef, length(A))
                for (i, w) in enumerate(A)
                    letters = Tuple(CharFrequency(c, V[findfirst(flw -> flw.letters[j].c == c, V)].letters[j].freq) for (j, c) in enumerate(w))
                    anagram_data[i] = FiveLetterWord(w, letters)
                end
                return anagram_data
                @label did_not_pass_ignore
            end
        end
    end
    
    return nothing
end
find_most_common_wordle_anagram(W::Vector{String}; default::Bool = true, ignore::Vector{Char} = Char[]) =
    find_most_common_wordle_anagram(default ? COMMON_FIVE_LETTER_WORDS_SORTED : first(_construct_frequency_map(W)); ignore = ignore)
find_most_common_wordle_anagram(; ignore::Vector{Char} = Char[]) = find_most_common_wordle_anagram(FIVE_LETTER_WORDS; default = true, ignore = ignore)


"""
```julia
find_most_common_wordles(V::Vector{FiveLetterWord}, wordlist::Vector{String}, n::Int; ignore::Vector{Char} = Char[]) -> FiveLetterWord  # if you give it characters in the `ignore` keyword argument, it will look for words not including those characters
find_most_common_wordles(W::Vector{String}, n::Int; default::Bool = true, ignore::Vector{Char} = Char[]) -> FiveLetterWord  # If `default`, will use the pre-generated (default) frequency list; otherwise will generate the list based on your word list
find_most_common_wordles(n::Int; ignore::Vector{Char} = Char[]) -> FiveLetterWord  # Uses default/pre-generated information to generate the best word
```
Similar to `find_most_common_wordle`, except it will return a list of `n` best wordles (`Vector{FiveLetterWord}`).
"""
function find_most_common_wordles(V::Vector{FiveLetterWord}, wordlist::Vector{String}, n::Int; ignore::Vector{Char} = Char[])
    chars_to_ignore = !isempty(ignore)
    top_count = 0
    candidates = FiveLetterWord[]
    words = Vector{FiveLetterWord}(undef, n)
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
    find_most_common_wordles(default ? COMMON_FIVE_LETTER_WORDS_SORTED : first(_construct_frequency_map(W)), W, n; ignore = ignore)
find_most_common_wordles(n::Int; ignore::Vector{Char} = Char[]) =
    find_most_common_wordles(FIVE_LETTER_WORDS, n; default = true, ignore = ignore)





using DataFrames
"Returns a dataframe of most common letters in each position, and their frequency count.  This is a function just for my own interest; not really any point in it"
function _make_naive_words_dataframe(wordlist::Vector{String})  # TODO: incorporate anagrams into this code
    V, Q = _construct_frequency_map(wordlist)

    df = DataFrame(c1 = Char[], c1_freq = Int[], c2 = Char[], c2_freq = Int[], c3 = Char[], c3_freq = Int[], c4 = Char[], c4_freq = Int[], c5 = Char[], c5_freq = Int[], word_score = Float64[])
    for i in 1:length(V)
        df_row = []
        for j in 1:5
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
    println("Best Wordle words to start with based on frequency analysis of ", length(FIVE_LETTER_WORDS), " words:")
    println("\tPosition-based: \t", "\"", flw_wordle.word, "\" (", get_word_score(flw_wordle), ")")
    println("\tAnagrams: \t\t", join((string("\"", w.word, "\" (", get_word_score(w.word), ")") for w in flws_anagram), ", "))
    
    flws = Wordle.find_most_common_wordles(20)
    for flw_wordle in flws
        println("\t\"", flw_wordle.word, "\" (", get_word_score(flw_wordle), ")")
    end
end

main()

#=
$ julia --project examples/Wordle.jl
Best Wordle words to start with based on frequency analysis:
	Position-based: 	"bares" (0.887)
	Anagrams: 		"basie" (0.555)

$ julia --project examples/Wordle.jl # Alt/Big
Best Wordle words to start with based on frequency analysis:
	Position-based: 	"corey" (0.854)
	Anagrams: 		"sayer" (0.732), "seary" (0.816), "resay" (0.65), "reasy" (0.675)

$ julia --project examples/Wordle.jl # Tree Alt/Big
Best Wordle words to start with based on frequency analysis:
	Position-based: 	"bares" (0.887)
	Anagrams: 		"beisa" (0.512), "abies" (0.68)

$ julia --project examples/Wordle.jl # next most common word not containing any of the characters "bare"
Best Wordle words to start with based on frequency analysis:
	Position-based: 	"coins" (0.726)
	Anagrams: 		"ostic" (0.178), "sciot" (0.479), "stoic" (0.437)

$ julia --project examples/Wordle.jl # next most common word not containing any of the characters "baes"
Best Wordle words to start with based on frequency analysis:
	Position-based: 	"corny" (0.58)
	Anagrams: 		"coiny" (0.598)
=#
