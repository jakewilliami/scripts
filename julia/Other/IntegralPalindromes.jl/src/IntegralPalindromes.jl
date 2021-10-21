module IntegralPalindromes

using Combinatorics
using DataStructures

include("iter.jl")

export ispalindrome, largest_palindrome
export ProdIter, ProdIter2

# TODO: only need to go to the middle of the digts
"""
```julia
ispalindrome(n::Integer) -> Bool
```
Returns a boolean value depending on whether or not the number is a palindrome.

For example, the number `9009` is a palindrome, because (just like the palindrome strings) can be read forward and backwards the same way.
"""
function ispalindrome(n::Integer)
    _digits = digits(n)
    n_digits = length(_digits) # ndigits(n)
    for i in 1:n_digits
        if _digits[i] != _digits[n_digits - i + 1]
            return false
        end
    end
    return true
end

function _prod_iter(lower::Int, upper::Int, m::Int)
    # sort!([a for a in Combinatorics.with_replacement_combinations(lower:upper, m)], by = prod, rev = true)
    A = collect(Combinatorics.multiset_permutations(lower:upper, m))
    for i in lower:upper
        push!(A, [i, i])
    end
    A = Vector{Int}[vcat(a, prod(a)) for a in A]
    return sort!(A, by = last, rev = true)
end

"""
```julia
larget_palindrome(n::Int, m::Int) -> (Int..., Int)
```
Computes the largest palindrome integer that is a product of m n-digit numbers.  Will return an (m + 1)-tuple, with the numbers whose product is a palindrome, and the product of such numbers in the last position of the tuple.

For example, with n = 2 and m = 2, the largest palindrome that is the product of two 2-digit numbers is 91 × 99 = 9009, so the function will return `(91, 99, 9009)`.
"""
function largest_palindrome(n::Int, m::Int)
    # get the lower and upper bound of n-digit numbers
    upper = 10^n - 1
    lower = 10^(n - 1)
    
    A = collect(Combinatorics.multiset_permutations(lower:upper, m))
    # We also need to add the pairs (i, i) for i in lower:upper, as
    # those are not included in multiset_permutations
    for i in lower:upper
        push!(A, [i, i])
    end
    # as we need to sort by prod, as well as check prod for
    # palindromeness, we should just add prod to the vector
    A = Vector{Int}[vcat(a, prod(a)) for a in A]
    # sort the combinations so that we can efficiently start from the top
    # we need to sort in reverse order to get the largest palindrome
    sort!(A, by = last, rev = true)
    
    # iterate over the combinations and check if it's a palindrome or not
    for a in A
        if ispalindrome(a[end])
            return (ntuple(j -> a[j], length(a) - 1)..., a[end])
        end
    end
    
    return ntuple(0, m + 1) # default to zero as answer for type stability
end

function largest_palindrome_iter(n::Int, m::Int)
    if m == 2
        # get the lower and upper bound of n-digit numbers
        upper = 10^n - 1
        lower = 10^(n - 1)
        
        for a in ProdIter2(lower, upper)
            if ispalindrome(last(a))
                return a
            end
        end
    else
        return largest_palindrome(n, m)
    end
end

end

for a in 99:-1:1
    for b in 99:-1:1
        
    end
end

99, 99
99, 98
99, 97
99, 96 <-
...
98, 98 <-
