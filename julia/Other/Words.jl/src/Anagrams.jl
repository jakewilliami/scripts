# TODO
#   - Implement a word limit (i.e., "james collins" cannot return "cones jam sill") if word limit is 2
#   - Implement tree struct using AbstractTrees, DataStructures, or LightGraphs—*or* use Dictionaries.jl
#   - MIN_WORD_SIZE

using Logging
using Combinatorics
using DataStructures: Trie
using AbstractTrees

export WORDLIST, WORDLIST_AS_TREE
export WORDLIST_BIG, WORDLIST_AS_TREE_BIG
export AnagramaticSentence
export areanagrams, find_anagrams

abstract type AbstractAnagramaticSentance end

struct AnagramaticSentence <: AbstractAnagramaticSentance
    words::Vector{String}
    permutations::Combinatorics.Permutations{Vector{String}}
    
    function AnagramaticSentence(words::Vector{String}, permutations::Combinatorics.Permutations{Vector{String}})
        return new(words, permutations)
    end
end
function AnagramaticSentence(words::Vector{String})
    AnagramaticSentence(words, Combinatorics.permutations(words))
end
Base.show(io::IO, S::AnagramaticSentence) = print(io, join(S.words, ' '))

# NOTE
# I have no idea what I'm doing with this tree structure
# abstract type AbstractWordlistTree end
#
# mutable struct WordlistTreeNode{T <: AbstractChar}
#     parent::Union{Char, T, Nothing}
#     children::Union{WordlistTreeNode{T}, Nothing}
# end
#
# mutable struct WordlistTree{T <: AbstractChar} <: AbstractWordlistTree
#     keys::Vector{Char}
#     values::Vector{WordlistTreeNode{T}}
# end
#
# WordlistTree{Char}(
#     ['c'],
#     WordlistTreeNode('c', [
#         WordlistTreeNode('a',
#             WordlistTreeNode('t',
#                 WordlistTreeNode(nothing, nothing)
#             )
#         )
#         ])
#     )
# children(W::WordlistTree) = ()

# helper functions for normalisation of strings
nopunct(s::AbstractString) = filter(c -> !ispunct(c), s)
nopunct(s) = nopunct(string(s))
nfcl(s::AbstractString) = Base.Unicode.normalize(s, decompose=true, compat=true, casefold=true, stripmark=true, stripignore=true)
canonicalise(s::AbstractString) = nopunct(nfcl(s))
normalise(s::AbstractString) = lowercase(strip(canonicalise(s)))

# struct Dictionary
#     parent::Char
#     finished::Bool
#     children::Dict{Char, Dictionary}
# end

function _make_tree_from_wordlist(wordlist::Vector{S}) where {S <: AbstractString}
    tree = Dict()

    function _add_to_tree!(tree::Dict, w_rem::AbstractString)
        c = w_rem[1]
        tree[c] = get(tree, c, Dict())
        if isone(length(w_rem))
            tree[c][:is_word] = true
        else
            tree[c] = _add_to_tree!(tree[c], w_rem[2:end])
        end
        return tree
    end

    for wᵢ in wordlist
        _add_to_tree!(tree, normalise(wᵢ))
    end

    return tree
end

const WORDLIST_PATH = realpath(joinpath(@__DIR__, "wordlist.txt"))
const WORDLIST_PATH_BIG = realpath(joinpath(@__DIR__, "wordlist_big.txt"))
const WORDLIST =  String[normalise(w) for w in readlines(WORDLIST_PATH)]
const WORDLIST_BIG = String[normalise(w) for w in readlines(WORDLIST_PATH_BIG) if length(w) > 1]
const WORDLIST_AS_TREE = _make_tree_from_wordlist(WORDLIST)
const WORDLIST_AS_TREE_BIG = _make_tree_from_wordlist(WORDLIST_BIG)

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
make_anagram(str::AbstractString, wordlist::Vector{<:AbstractString}; nwords::Union{Int, Nothing} = nothing, verbose::Bool = true) -> Vector{AnagramaticSentence}
find_anagrams(str::AbstractString, wordlist::Vector{<:AbstractString}; nwords::Union{Int, Nothing} = nothing, verbose::Bool = true)  -> Vector{AnagramaticSentence}
find_anagrams(str::AbstractString, path_to_wordlist::AbstractString; nwords::Union{Int, Nothing} = nothing, verbose::Bool = true)  -> Vector{AnagramaticSentence}
```

Find anagrams of `str` given a `wordlist`.

Given a word, will check if every permutation of the characters in the word can create some (potentially multi-word) phrase in the wordlist.

The `nwords` keyword argument will limit the number of resulting words your anagram can be.
"""
function find_anagrams(str::S, tree::Dict; nwords::Union{Int, Nothing} = nothing, verbose::Bool = true) where {S <: AbstractString}
    str_stripped = normalise(_skipblanks(str))
    str_len = length(str_stripped)
    start_i = 1
    has_limit = !isnothing(nwords)
    
    anagrams = AnagramaticSentence[]
    for sⱼ in Combinatorics.multiset_permutations(str_stripped, str_len)
        # initialise current tree, and some useful temporary structures
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
            # if isnothing(get(possible_value, nothing, "something"))
                if i == str_len
                    push!(multiple_words, sⱼ[(start_i):end])
                    this_sentence = String[join(w) for w in multiple_words]
                    # skip if it doesn't fit into the constraint on the number of words
                    if has_limit
                        if nwords ≤ length(this_sentence)
                            break
                        end
                    end
                    # sort so that result ["a", "b"] does not appear if ["b", "a"] is already in the list
                    sort!(this_sentence)
                    # also ensure that this sentence is not the same as the first
                    # we can't just skip the first word because "potter harry" is still "harry potter", sorted
                    if this_sentence ∉ (w.words for w in anagrams) #&& join(this_sentence) != str_stripped
                        push!(anagrams, AnagramaticSentence(this_sentence))
                        # if verbose, say we found something
                        if verbose
                            Logging.@info "Anagram found: \"$(join(this_sentence, ' '))\""
                        end
                    end
                    # empty the multiple_words vector and start again
                    empty!(multiple_words)
                    tree_current = tree
                    start_i = 1
                else
                    # potential start of a phrase.  log information
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
function find_anagrams(str::S1, wordlist::Vector{S2}; nwords::Union{Int, Nothing} = nothing, verbose::Bool = true) where {S1 <: AbstractString, S2 <: AbstractString}
    tree = _make_tree_from_wordlist(wordlist)
    return find_anagrams(str, tree; nwords = nwords, verbose = verbose)
end
function find_anagrams(str::S1, path_to_wordlist::S2; nwords::Union{Int, Nothing} = nothing, verbose::Bool = true) where {S1 <: AbstractString, S2 <: AbstractString}
    wordlist = readlines(path_to_wordlist)
    tree = _make_tree_from_wordlist(wordlist)
    return find_anagrams(str, tree; nwords = nwords, verbose = verbose)
end
