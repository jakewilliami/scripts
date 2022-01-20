using Logging
using IterTools
using ResumableFunctions # for yeild-like properties


export WORDLIST, WORDLIST_AS_TREE
export WORDLIST_BIG, WORDLIST_AS_TREE_BIG
# export WORDLIST_ALT, WORDLIST_AS_TREE_ALT  # TODO: see below todo
export WORDLIST_SCRABBLE, WORDLIST_AS_TREE_SCRABBLE
export areanagrams, get_anagram_map
export load_dictionary, anagrams


# helper functions for normalisation of strings
_skipblanks(s::String) = filter(c -> c != ' ', s)
_nopunct(s::String) = filter(c -> !ispunct(c), s)
_nfcl(s::String) = Base.Unicode.normalize(s, decompose=true, compat=true, casefold=true,
                                        stripmark=true, stripignore=true)
_canonicalise(s::String) = _nopunct(_nfcl(s))
_normalise(s::String) = lowercase(_skipblanks(_canonicalise(s)))


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


# Dictionary stuff
"""
```julia
Base.@kwdef mutable struct Dictionary
    path::String = ""
    finished::Bool = false
    parent::Union{Dictionary, Nothing} = nothing
    children::Dict{Union{Char, String}, Dictionary} = Dict{Union{Char, String}, Dictionary}()
end
```
A tree-like dictionary structure to efficiently find anagrams.
"""
Base.@kwdef mutable struct Dictionary
    path::String = ""
    finished::Bool = false
    parent::Union{Dictionary, Nothing} = nothing
    children::Dict{Union{Char, String}, Dictionary} = Dict{Union{Char, String}, Dictionary}()
    
    function Dictionary(path::String, finished::Bool, parent::Union{Dictionary, Nothing}, children::Dict{Union{Char, String}, Dictionary})
        return new(path, finished, parent, children)
    end
end


get_root(D::Dictionary) = isnothing(D.parent) ? D : get_root(D.parent)


function ingest!(D::Dictionary, word::String)
    if !isempty(word)
        word = _normalise(word)
        default_D = Dictionary(path = string(D.path, word[1]), parent = D)
        child = get(D.children, word[1], default_D)
        ingest!(child, word[2:end])
        D.children[word[1]] = child
    else
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


"""
```julia
load_dictionary(path_to_wordlist::String) -> Dictionary
load_dictionary(wordlist::Vector{String} -> Dictionary
```
Loads wordlist into a tree-like structure for efficient anagram searching.
"""
function load_dictionary(path::String)
    D = Dictionary()
    open(path, "r") do io
        ingest_all!(D, readlines(io))
    end
    return D
end
load_dictionary(words::Vector{String}) = ingest_all!(Dictionary(), words)


# load constant wordlists
## TODO: Fix alt wordlist being broken (too big, causing `anagrams` to stack overflow)
    ## julia> format((length(WORDLIST), length(WORDLIST_BIG), length(WORDLIST_ALT), length(WORDLIST_SCRABBLE)), commas = true)
    ## ("45,374", "235,886", "354,986", "267,751")
const WORDLIST_PATH = realpath(joinpath(@__DIR__, "wordlist.txt"))
const WORDLIST_PATH_BIG = realpath(joinpath(@__DIR__, "wordlist_big.txt"))
# const WORDLIST_PATH_ALT = realpath(joinpath(@__DIR__, "wordlist_alt.txt"))
const WORDLIST_PATH_SCRABBLE = realpath(joinpath(@__DIR__, "wordlist_sowpods.txt"))
const WORDLIST =  String[_normalise(w) for w in readlines(WORDLIST_PATH)]
const WORDLIST_BIG = String[_normalise(w) for w in readlines(WORDLIST_PATH_BIG)]
# const WORDLIST_ALT = String[_normalise(w) for w in readlines(WORDLIST_PATH_ALT)]
const WORDLIST_SCRABBLE = String[_normalise(w) for w in readlines(WORDLIST_PATH_SCRABBLE)]
const WORDLIST_AS_TREE = load_dictionary(WORDLIST)
const WORDLIST_AS_TREE_BIG = load_dictionary(WORDLIST_BIG)
# const WORDLIST_AS_TREE_ALT = load_dictionary(WORDLIST_ALT)
const WORDLIST_AS_TREE_SCRABBLE = load_dictionary(WORDLIST_SCRABBLE)


# main methods
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
```julia
get_anagram_map(str1::String, str2::String) -> Dict{Tuple{Char, Int}, Int}
```
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


@resumable function anagrams(D::Dictionary, subject::String)
    subject = _normalise(subject)
    if D.finished && isempty(subject)
        # Base case 1: Perfect match
        @yield D.path
    elseif D.finished
        # Base case 2: Hit end of path but still more string
        for anagram in anagrams(get_root(D), subject)
            @yield string(D.path, ' ', anagram)
        end
    end
    # Keep recursing deeper
    # for c in unique(subject)
    for c in IterTools.distinct(subject)
        if c ∈ keys(D.children)
            for anagram in anagrams(D.children[c], remove_first_char(subject, c))
                @yield anagram
            end
        end
    end
end


"""
```julia
anagrams(D::Dictionary, subject::String)
areanagrams(wordlist_path::String, subject::String)
```

This returns a resumable iterator, which one can iterate over or `collect`.

In general, one should use the provided `WORDLIST_AS_TREE` or `WORDLIST_AS_TREE_BIG` for the `Dictionary` argument.  If one has their own word list, one can provide the path to said word list.
"""
anagrams(wordlist_path::String, subject::String) =
    anagrams(load_dictionary(wordlist_path), subject)
