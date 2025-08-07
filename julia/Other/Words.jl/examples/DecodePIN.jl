include(joinpath(dirname(@__DIR__), "src", "Anagrams.jl")) # WORDLIST_SCRABBLE

const NUMPAD_CHARS = Vector{Char}[['␣'],                  # 0
                                  ['➿'],                 # 1
                                  ['a', 'b', 'c'],        # 2
                                  ['d', 'e', 'f'],        # 3
                                  ['g', 'h', 'i'],        # 4
                                  ['j', 'k', 'l'],        # 5
                                  ['m', 'n', 'o'],        # 6
                                  ['p', 'q', 'r', 's'],   # 7
                                  ['t', 'u', 'v'],        # 8
                                  ['w', 'x', 'y', 'z']]   # 9

function string2pin(s::S) where {S <: AbstractString}
    io = IOBuffer()
    for c in s
        i = findfirst(v -> c ∈ v, NUMPAD_CHARS)
        @assert(!isnothing(i), "Cannot lower character \'$c\' to a digit on a regular num pad")
        print(io, i - 1)
    end
    return String(take!(io))
end

possibile_char_permutations_lazy(numbers::Vector{Int}) =
    foldr((itr1, itr2) -> ((v, w...) for w in itr2 for v in itr1), Vector{Char}[NUMPAD_CHARS[i + 1] for i in numbers])
# TODO: make the following code work, as it is optimised over the `foldr` code:
    # nrows, ncols = size(M)
    # M_permutations = Matrix{CharFrequency}(undef, nrows^ncols, ncols) # similar(M, nrows^ncols, ncols)
    # for i in axes(M, 2) # 1:nrows
        # M_permutations[:, i] .= repeat(view(M, :, i), inner = nrows^(ncols - i), outer = nrows^(i - 1))
    # end
    # n, m  = (prod(length, numbers), length(numbers))
    # M_permutations = Matrix{Char}(undef, n, m)
    # for i in axes(numbers)
        # M_permutations[:, i] = repeat(, inner = )
    # end

function find_possible_words(pin::Vector{Int})
    possible_permutations = possibile_char_permutations_lazy(pin)
    words = String[]
    for word_chars in possible_permutations
        word = join(word_chars)
        if word ∈ WORDLIST_SCRABBLE
            push!(words, word)
        end
    end
    return words
end
find_possible_words(pin::Int) = find_possible_words(reverse(digits(pin)))
find_possible_words(pin::String) = find_possible_words(Int[parse(Int, c) for c in pin])

# println(find_possible_words(5253))
# println(find_possible_words(3345))
# println(find_possible_words(5683))
println(find_possible_words(2028))

# Example: 5683 -> [..., "love", ...]
println(string2pin("maze"))
