#=
using Combinatorics
using StatsBase

_SONNET_PATH = "../data/sonnets.txt"

# TODO: equivalent to combinations??
function choose(k::Int, xs::Vector{T})::Vector{Vector{T}} where {T}
    iszero(k) && return Vector{T}[T[]]
    isempty(xs) && return Vector{T}[]
    x, rest = Iterators.peel(xs)
    res = Vector{T}[vcat(x, c) for c in choose(k - 1, rest)]
    append!(res, choose(k, rest))
    return res
end

function remove_every(n::Int, xs::Vector{T})::Vector{T} where {T}
    return T[x for (i, x) in enumerate(xs) if !iszero(mod(i, n))]
end

function scheme_to_indices(scheme::String)::Vector{Vector{Int}}
    return Vector{Int}[Int[i for (i, c) in enumerate(scheme) if c == s] for s in unique(scheme)]
end

function _lastword(s::String)
    # return split(s)[end]  # this performs worse for larger sentences
    s = reverse(s)
    parts = split(s, limit=2)
    return reverse(first(parts))
end

function rhymes(scheme::String, ls::Vector{String})::Vector{String}
    rhyming_pairs = scheme_to_indices(scheme)
    pairs = [(i, j) for pair in combinations(rhyming_pairs, 2) for (i, j) in Iterators.product(pair...)]
    return String["$(ls[i]) $(ls[j])" for (i, j) in pairs if i != j && _lastword(ls[i]) != _lastword(ls[j])]
end

function get_sonnets(path::String)::Vector{Vector{String}}
    paragraphs = split(readchomp(path), "\n\n")
    return [split(p, "\n") for p in remove_every(2, paragraphs)]
end

function format_map(D::Vector{String})::Vector{String}
    m = sort(countmap(D), byvalue = true, rev = true)
    return ["$(count)\t$(item)" for (item, count) in m]
end

function main()
    sonnets = get_sonnets(_SONNET_PATH)
    rhyming_pairs = rhymes("ababcdcdefefgg", [word for s in sonnets for word in s])
    for m in format_map(rhyming_pairs)
        println(m)
    end
end

# main()


=#


using Combinatorics
using OrderedCollections
using StatsBase


_SONNET_PATH = "../data/sonnets.txt"


struct UnorderedPair{T}
    data::Set{T}

    function UnorderedPair(data::Set{T}) where {T}
        length(data) == 2 || error("Cannot construct unordered pair")
        return new{T}(data)
    end
end
UnorderedPair(a::T, b::T) where {T} = UnorderedPair(Set((a, b)))
UnorderedPair(data) = UnorderedPair(Set(data))
Base.:(==)(a::UnorderedPair, b::UnorderedPair) = a.data == b.data
Base.collect(p::UnorderedPair) = collect(p.data)
Base.show(io::IO, p::UnorderedPair) =
    print(io, "UnorderedPair(", collect(p.data), ")")



function remove_every_n(n::Int, A::Vector{T}) where {T}
    B = Vector{T}(undef, ceil(Int, length(A) * ((n - 1) / n)))
    aᵢ, bᵢ = 1, 1
    while aᵢ <= length(A)
        if mod(aᵢ, n) != 0
            B[bᵢ] = A[aᵢ]
            bᵢ += 1
        end
        aᵢ += 1
    end
    return B
end


function scheme_to_indices(scheme::String)::Vector{Vector{Int}}
    # This is more efficient but only on smaller input:
    # return Vector{Int}[Int[i for (i, c) in enumerate(scheme) if c == s] for s in unique(scheme)]

    D = Dict{Char, Vector{Int}}()
    for (i, c) in enumerate(scheme)
        if haskey(D, c)
            push!(D[c], i)
        else
            D[c] = Int[i]
        end
    end

    return collect(values(sort(D)))
end


function lastword(s::S) where {S <: AbstractString}
    # This performs worse for larger sentences:
    # return split(s)[end]

    # This works okay for larger senteces:
    #=
    s = reverse(s)
    parts = split(s, limit=2)
    return reverse(first(parts))
    =#

    # This is best for large sentences, avoiding split entirely:
    i = findlast(isspace, s)
    i === nothing && return s
    return SubString(s, nextind(s, i), lastindex(s))
end


function rhymes(scheme::String, A::Vector{String})::Vector{UnorderedPair}
    rhyming_pairs = scheme_to_indices(scheme)
    # println(rhyming_pairs)
    # println([x for x in combinations(rhyming_pairs, 2)])

    rhyme(s::S) where {S <: AbstractString} = rstrip(ispunct, lastword(s))


    pairs = [(i, j) for pair in combinations(rhyming_pairs, 2) for (i, j) in Iterators.product(pair...)]
    return [UnorderedPair(rhyme(A[i]), rhyme(A[j])) for (i, j) in pairs if i != j && rhyme(A[i]) != rhyme(A[j])]



    return [UnorderedPair(A[i], A[j])
            for (i, j) in combinations(rhyming_pairs, 2)
                if rhyme(A[i]) == rhyme(A[j])]


    function get_pair(B::Vector{Int})
        return [
            UnorderedPair(x, y)
            for (x, y) in
                combinations(map(A, B), 2)
                if rhyme(x) == rhyme(y)
        ]
    end
    return vcat(map(get_pair, rhyming_pairs)...)



    [rhyme(A[i]) for i in combinations(group, 2)]

    # Group the words in A by their rhyming sounds
    groups = Dict{String, Vector{Int}}()
    for (i, s) in enumerate(A)
        rhyme = get_rhyme(s)
        if haskey(groups, rhyme)
            push!(groups[rhyme], i)
        else
            groups[rhyme] = [i]
        end
    end

    # Generate all pairs of rhyming words within each group
    pairs = UnorderedPair[]
    for group in values(groups)
        for (i, j) in combinations(group, 2)
            push!(pairs, UnorderedPair(i, j))
        end
    end

    return pairs
end



function get_sonnets(path::String)::Vector{Vector{String}}
    paragraphs = split(readchomp(path), "\n\n")
    return [split(p, "\n") for p in remove_every_n(2, paragraphs)]
end

function format_map(D::Vector{UnorderedPair})::Vector{String}
    m = sort(countmap(D), byvalue = true, rev = true)
    return ["$(count)\t$(item)" for (item, count) in m]
end

function main()
    sonnets = get_sonnets(_SONNET_PATH)
    rhyming_pairs = rhymes("ababcdcdefefgg", [word for s in sonnets for word in s])
    for m in format_map(rhyming_pairs)
        println(m)
    end
end

main()
