# TODO
#   - Implement tree struct using AbstractTrees, DataStructures, or LightGraphs—*or* use Dictionaries.jl

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

#=
"""
```julia
make_anagram(str::AbstractString, wordlist::Vector{<:AbstractString}; nwords::Union{Int, Nothing} = nothing, min_word_size::Union{Int, Nothing} = nothing, allow_identity::Bool = false, verbose::Bool = true) -> Vector{AnagramaticSentence}
find_anagrams(str::AbstractString, wordlist::Vector{<:AbstractString}; nwords::Union{Int, Nothing} = nothing, min_word_size::Union{Int, Nothing} = nothing, allow_identity::Bool = false, verbose::Bool = true)  -> Vector{AnagramaticSentence}
find_anagrams(str::AbstractString, path_to_wordlist::AbstractString; nwords::Union{Int, Nothing} = nothing, min_word_size::Union{Int, Nothing} = nothing, allow_identity::Bool = false, verbose::Bool = true)  -> Vector{AnagramaticSentence}
```

Find anagrams of `str` given a `wordlist`.

Given a word, will check if every permutation of the characters in the word can create some (potentially multi-word) phrase in the wordlist.

The `nwords` keyword argument will limit the number of resulting words your anagram can be.

The `min_word_size` keyword argument will only obtain `AnagramaticSentence`s contain words of length greater than or equal to `min_word_size`.
"""
function find_anagrams(str::S, tree::Dict; nwords::Union{Int, Nothing} = nothing, min_word_size::Union{Int, Nothing} = nothing, allow_identity::Bool = false, verbose::Bool = true) where {S <: AbstractString}
    str_stripped = normalise(_skipblanks(str))
    str_len = length(str_stripped)
    start_i = 1
    has_limit = !isnothing(nwords)
    constrain_word = !isnothing(min_word_size)
    
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
                    # ensure the minimum word size constraint is acknowledged
                    if constrain_word
                        if !all(length(w) ≥ min_word_size for w in this_sentence)
                        # for w in this_sentence
                            # if length(w) ≤ min_word_size
                            break
                            # end
                        end
                    end
                    # sort so that result ["a", "b"] does not appear if ["b", "a"] is already in the list
                    sort!(this_sentence)
                    if this_sentence ∉ (w.words for w in anagrams)
                        # also ensure that this sentence is not the same as the input
                        # we can't just skip the first word because "potter harry" is still "harry potter", sorted
                        if allow_identity || (!allow_identity && join(this_sentence) != str_stripped)
                            push!(anagrams, AnagramaticSentence(this_sentence))
                            # if verbose, say we found something
                            if verbose
                                Logging.@info "Anagram found: \"$(join(this_sentence, ' '))\""
                            end
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
function find_anagrams(str::S1, wordlist::Vector{S2}; nwords::Union{Int, Nothing} = nothing, min_word_size::Union{Int, Nothing} = nothing, allow_identity::Bool = false, verbose::Bool = true) where {S1 <: AbstractString, S2 <: AbstractString}
    tree = _make_tree_from_wordlist(wordlist)
    return find_anagrams(str, tree; nwords = nwords, min_word_size = min_word_size, allow_identity = allow_identity, verbose = verbose)
end
function find_anagrams(str::S1, path_to_wordlist::S2; nwords::Union{Int, Nothing} = nothing, min_word_size::Union{Int, Nothing} = nothing, allow_identity::Bool = false, verbose::Bool = true) where {S1 <: AbstractString, S2 <: AbstractString}
    wordlist = readlines(path_to_wordlist)
    tree = _make_tree_from_wordlist(wordlist)
    return find_anagrams(str, tree; nwords = nwords, min_word_size = min_word_size, allow_identity = allow_identity, verbose = verbose)
end
=#

using IterTools

nopunct(s::String) = filter(c -> !ispunct(c), s)
nopunct(s) = nopunct(string(s))
nfcl(s::String) = Base.Unicode.normalize(s, decompose=true, compat=true, casefold=true,
                                        stripmark=true, stripignore=true)
canonicalise(s::String) = nopunct(nfcl(s))
format(s::String) = lowercase(strip(canonicalise(s)))

function remove_first_char(w::String, c::Char)
    io = IOBuffer()
    i = findfirst(==(c), w)
    for (j, cⱼ) in enumerate(w)
        if j ≠ i
            print(io, cⱼ)
        end
    end
    return String(take!(io))
end

Base.@kwdef mutable struct Dictionary
    path::String = ""
    finished::Bool = false
    parent::Union{Dictionary, Nothing} = nothing
    children::Dict{Union{Char, String}, Dictionary} = Dict{Union{Char, String}, Dictionary}()
    
    function Dictionary(path::String, finished::Bool, parent::Union{Dictionary, Nothing}, children::Dict{Union{Char, String}, Dictionary})
        return new(path, finished, parent, children)
    end
end

function get_root(D::Dictionary)
    return isnothing(D.parent) ? D : get_root(D.parent)
end

function ingest!(D::Dictionary, word::String)
    if !isempty(word)
        word = format(word)
        default_D = Dictionary(path = string(D.path, word[1]), parent = D)
        child = get(D.children, word[1], default_D)
        ingest!(child, word[2:end])
        D.children[word[1]] = child
    else
        # @info "finished $word: $(length(word))"
        D.finished = true
    end
    return D
end

function ingest_all!(D::Dictionary, words::Vector{String})
    for w in words
        ingest!(D, w)
    end
    return D
end

function load_dictionary(path::String)
    D = Dictionary()
    open(path, "r") do io
        ingest_all!(D, readlines(io))
    end
    return D
end

mutable struct Anagrams
    dict::Dictionary
    chars::Vector{Char}
    subject::String
    function Anagrams(dict::Dictionary, chars::Vector{Char}, subject::String)
        # ensure subject is appropriately formatted
        new(dict, chars, format(subject))
    end
end
function Anagrams(dict::Dictionary, subject::String)
    subject = format(subject)
    chars = Char[c for c in subject] # collect(subject)
    return Anagrams(dict, chars, subject)
end
# struct Squares
#     count::Int
# end
# function Base.iterate(S::Squares, state=1)
#     if state > S.count
#         return nothing
#     else
#         return (state*state, state+1)
#     end
# end
# function Base.iterate(A::Anagrams)
#
# end
function Base.iterate(A::Anagrams, state)
    println(state)
    if A.dict.finished && isempty(A.subject)
        # Base case 1: Perfect match
        return (A.dict.path, state + 1)
    elseif A.dict.finished
        # Base case 2: Hit end of path but still more string
        # i = 0
        for anagram in Anagrams(get_root(A.dict), A.subject)
            return (string(A.dict.path, ' ', anagram), state + 1)
        end
        return (nothing, state + 1)
        # return nothing
    end
    
    # Keep recursing deeper
    # for c in IterTools.distinct(A.subject)
    for c in unique(A.subject)
        if c ∈ keys(A.dict.children)
            for anagram in Anagrams(A.dict.children[c], remove_first_char(A.subject, c))
                return (anagram, state + 1)
            end
            # return nothing
            return (nothing, state + 1)
        end
    end
    
    # return (nothing, state + 1)
end
Base.length(::Anagrams) = 88

# function Base.HasLength()
# end
# IteratorSize(IterType)	HasLength()	One of HasLength(), HasShape{N}(), IsInfinite(), or SizeUnknown() as appropriate
# IteratorEltype(IterType)	HasEltype()	Either EltypeUnknown() or HasEltype() as appropriate
# eltype(IterType)	Any	The type of the first entry of the tuple returned by iterate()
# length(iter)	(undefined)	The number of items, if known
# size(iter, [dim])	(undefined)	The number of items in each dimension, if known

using ResumableFunctions
@resumable function anagrams_resumable(D::Dictionary, subject::String)
    subject = format(subject)
    if D.finished && isempty(subject)
        # Base case 1: Perfect match
        @yield D.path
    elseif D.finished
        # Base case 2: Hit end of path but still more string
        for anagram in anagrams_resumable(get_root(D), subject)
            @yield string(D.path, ' ', anagram)
        end
    end
    # Keep recursing deeper
    # for c in unique(subject)
    for c in IterTools.distinct(subject)
        if c ∈ keys(D.children)
            for anagram in anagrams_resumable(D.children[c], remove_first_char(subject, c))
                @yield anagram
            end
        end
    end
end

function anagrams_channels(D::Dictionary, subject::String)
    subject = format(subject)
    Channel{String}() do ch
        if D.finished && isempty(subject)
            # Base case 1: Perfect match
            put!(ch, D.path)
        elseif D.finished
            # Base case 2: Hit end of path but still more string
            for anagram in anagrams_channels(get_root(D), subject)
                put!(ch, string(D.path, ' ', anagram))
            end
        end
        # Keep recursing deeper
        # for c in unique(subject)
        for c in IterTools.distinct(subject)
            if c ∈ keys(D.children)
                for anagram in anagrams_channels(D.children[c], remove_first_char(subject, c))
                    put!(ch, anagram)
                end
            end
        end
    end
end

# distinct(xs::I) where {I} = Distinct{I, eltype(xs)}(xs, Dict{eltype(xs), Int}())
#
# function iterate(it::Distinct, state=(1,))
#     idx, xs_state = first(state), tail(state)
#     xs_iter = iterate(it.xs, xs_state...)
#
#     while xs_iter !== nothing
#         val, xs_state = xs_iter
#         get!(it.seen, val, idx) >= idx && return (val, (idx + 1, xs_state))
#
#         xs_iter = iterate(it.xs, xs_state)
#         idx += 1
#     end
#
#     return nothing
# end

path_to_wordlist = joinpath(dirname(dirname(@__DIR__)), "wordlist.txt")
D = load_dictionary(path_to_wordlist)
# A = [a for a in anagrams(D, "Zoë Christall")]
# for anagram in anagrams(D, "Liam Peck")
#     println("- $anagram")
# end
# A = [a for a in Anagrams(D, "Liam Peck")]
# for anagram in Anagrams(D, "Liam Peck")
#     println("- $anagram")
# end

#= Benchmarking =#

using BenchmarkTools
include(joinpath(dirname(dirname(@__DIR__)), "Anagrams.jl"))

# A = @btime find_anagrams("Liam Peck", WORDLIST_AS_TREE; verbose = false);
# B = @btime [a for a in anagrams_resumable(D, "Liam Peck")];
# C = @btime [a for a in anagrams_channels(D, "Liam Peck")];
D = [a for a in Anagrams(D, "Liam Peck")]
