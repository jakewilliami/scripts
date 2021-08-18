module Words

using DataStructures: Trie, Stack, Queue
using AbstractTrees

function _make_tree_from_wordlist(wordlist::Vector{S}) where {S <: AbstractString}
    tree = Dict()

    function _add_to_tree!(tree::Dict, w_rem::AbstractString)
        c = w_rem[1]
        tree[c] = get(tree, c, Dict())
        if isone(length(w_rem))
            tree[c][:is_word] = true
            # tree[c][nothing] = nothing
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

# function _make_tree_from_wordlist(wordlist::Vector{S}) where {S <: AbstractString}
#     tree = Dict()
# end

export WORDLIST, LONGEST_PALINDROME

const WORDLIST_PATH = realpath(joinpath(@__DIR__, "wordlist.txt"))
const WORDLIST = readlines(WORDLIST_PATH)
const LONGEST_PALINDROME = "tattarrattat"
const WORDLIST_AS_TREE = _make_tree_from_wordlist(WORDLIST)

# include("Acronyms.jl")
include("Acrostics.jl")
include("Anagrams.jl")
# include("Forkerisms.jl")
# include("Kniferisms.jl")
include("Palindromes.jl")
# include("Senryus.jl")
# include("Sonnets.jl")
# include("Spoonerisms.jl")

end
