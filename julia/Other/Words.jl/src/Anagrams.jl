using Logging
using Combinatorics: permutations
using DataStructures: Trie
using AbstractTrees

export WORDLIST, WORDLIST_AS_TREE
export areanagrams, find_anagrams

function _make_tree_from_wordlist(wordlist::Vector{S}) where {S <: AbstractString}
    tree = Dict()

    function _add_to_tree!(tree::Dict, w_rem::AbstractString)
        c = w_rem[1]
        tree[c] = get(tree, c, Dict())
        if isone(length(w_rem))
            tree[c][:is_word] = true
            tree[c][nothing] = nothing
        else
            tree[c] = _add_to_tree!(tree[c], w_rem[2:end])
        end
        return tree
    end

    for wᵢ in wordlist
        _add_to_tree!(tree, lowercase(wᵢ))
    end

    return tree
end

# t = Trie{Int}()
# t["Rob"] = 42
# t["Roger"] = 24
# haskey(t, "Rob")  # true
# get(t, "Rob", nothing)  # 42
# keys(t)  # "Rob", "Roger"
# keys(subtrie(t, "Ro"))  # "b", "ger"

function _make_trie_from_wordlist(wordlist::Vector{S}) where {S <: AbstractString}
    T = Trie{Char}()
    
    for wᵢ in wordlist
        wᵢ = lowercase(wᵢ)
        c = w_rem[1]
        T[c] = get(T, c, Dict())
        if isone(length(w_rem))
            tree[c][:is_word] = true
            # tree[c][nothing] = nothing
        else
            T[c] = _add_to_tree!(tree[c], w_rem[2:end])
        end
    end
    
    # function _add_to_tree!(tree::Dict, w_rem::AbstractString)
    #     c = w_rem[1]
    #     tree[c] = get(tree, c, Dict())
    #     if isone(length(w_rem))
    #         tree[c][:is_word] = true
    #         # tree[c][nothing] = nothing
    #     else
    #         tree[c] = _add_to_tree!(tree[c], w_rem[2:end])
    #     end
    #     return tree
    # end
    #
    # for wᵢ in wordlist
    #     _add_to_tree!(tree, lowercase(wᵢ))
    # end

    return T
end

const WORDLIST_PATH = realpath(joinpath(@__DIR__, "wordlist.txt"))
const WORDLIST = readlines(WORDLIST_PATH)
const WORDLIST_AS_TREE = _make_tree_from_wordlist(WORDLIST)

function _skipblanks(str::S) where {S <: AbstractString}
    return filter(c -> c != ' ', str)
end

"""
```julia
areanagrams(str1::AbstractString, str2::AbstractString) -> Bool
```

Given 2 words, checks if they are anagrams of each other.
"""
function areanagrams(str1::S1, str2::S2) where {S1 <: AbstractString, S2 <: AbstractString}
    length(str1) != length(str2) && return false
    
    # check above *after* removing blanks???
    str1, str2 = (_skipblanks(str1), _skipblanks(str2))
    
    str2_arr = collect(str2)
    
    for c1 in str1
        i = findfirst(==(c1), str2_arr)
        !isnothing(i) && deleteat!(str2_arr, i)
    end

    return isempty(str2_arr)
end

"""
Creates a hashmap of (character, index 1) => index2.
"""
function get_anagram_map(str1::S1, str2::S2) where {S1 <: AbstractString, S2 <: AbstractString}
    areanagrams(str1, str2) || error("$str1 is not an anagram of $str2, so we cannot perform this function")
    
    out_map = Dict{Tuple{Char, Int}, Int}()
    str2_arr = collect(str2)
    
    for (i1, c1) in enumerate(str1)
        i2 = findfirst(==(c1), str2_arr)
        push!(out_map, (c1, i1) => i2)
        deleteat!(str2_arr, i2)
    end
    
    return out_map
end

"""
```julia
make_anagram(str::AbstractString, wordlist::Vector{<:AbstractString}; verbose::Bool = true) -> Vector{<:AbstractString}
find_anagrams(str::AbstractString, wordlist::Vector{<:AbstractString}; verbose::Bool = true)  -> Vector{<:AbstractString}
find_anagrams(str::AbstractString, path_to_wordlist::AbstractString; verbose::Bool = true)  -> Vector{<:AbstractString}
```

Find anagrams of `str` given a `wordlist`.

Given a word, will check if every permutation of the characters in the word can create some (potentially multi-word) phrase in the wordlist.
"""
function find_anagrams(str::S, tree::Dict; verbose::Bool = true) where {S <: AbstractString}
    str_stripped = lowercase(_skipblanks(str))
    str_len = length(str_stripped)
    start_i = 1
    
    anagrams = Vector{String}[] # each vector contains at least one word that creats the anagram
    
    for sⱼ in permutations(str_stripped)
        tree_current = tree
        multiple_words = Vector{Char}[] # each vector of characters is a word
        # savepoint = Stack{Tuple{Int, Int, Dict}}() # using DataStructures' Stack slows the programme down substantially (by 100 ms on an 8-letter word)
        savepoint = Tuple{Int, Int, Dict}[]
        i = 0
        while true
            i += 1
            i > str_len && break
            c = sⱼ[i]
            possible_value = get(tree_current, c, Dict())
            if get(possible_value, :is_word, false)
                if i == str_len
                    push!(multiple_words, sⱼ[(start_i):end])
                    this_sentence = String[join(w) for w in multiple_words]
                    # sort so that result ["a", "b"] does not appear if ["b", "a"] is already in the list
                    sort!(this_sentence)
                    if this_sentence ∉ anagrams
                        push!(anagrams, this_sentence)
                        if verbose
                            Logging.@info "Anagram found: \"$(join(this_sentence, ' '))\""
                        end
                    end
                    empty!(multiple_words)
                    tree_current = tree
                    start_i = 1
                else
                    push!(savepoint, (start_i, i, tree_current[c]))
                    push!(multiple_words, sⱼ[start_i:i])
                    tree_current = tree
                    start_i = i + 1
                end
            else
                if (isempty(possible_value) || i == str_len) && !isempty(savepoint)
                    start_i, i, tree_current = pop!(savepoint)
                    multiple_words = multiple_words[1:(end - 1)]
                else
                    tree_current = get(tree_current, c, Dict())
                end
            end
        end
    end
        
    return anagrams
end
function find_anagrams(str::S1, wordlist::Vector{S2}; verbose::Bool = true) where {S1 <: AbstractString, S2 <: AbstractString}
    tree = _make_tree_from_wordlist(wordlist)
    return find_anagrams(str, tree; verbose = verbose)
end
function find_anagrams(str::S1, path_to_wordlist::S2; verbose::Bool = true) where {S1 <: AbstractString, S2 <: AbstractString}
    wordlist = readlines(path_to_wordlist)
    tree = _make_tree_from_wordlist(wordlist)
    return find_anagrams(str, tree; verbose = verbose)
end

function make_anagramatic_name(str::S) where {S <: AbstractString}
    # for this function, we need to figure out a way to make a word which *sounds like* a word...NLP...
end
