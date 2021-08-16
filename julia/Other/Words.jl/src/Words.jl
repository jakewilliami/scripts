module Words



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
