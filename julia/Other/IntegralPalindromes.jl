using Combinatorics

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

"""
Largest palindrome from the product of m `n`-digit numbers
for example, the largest palindrome from the product of 2 2-digit numbers
is 91 × 99 == 9009
"""
function largest_palindrome(n::Int, m::Int)
    # get the lower and upper bound of 
    upper = 10^n - 1
    lower = 10^(n - 1)
    
    A = Vector{Vector{Int}}()
    for a in combinations(lower:upper, m)
        # as we need to sort by prod, as well as check prod for 
        # palindromeness, we should just add prod to the vector
        push!(A, vcat(a, prod(a)))
    end
    # sort the combinations so that we can efficiently start from the top
    sort!(A, by = last)
    
    # iterate over the combinations and check if it's a palindrome or not
    # we need to iterate in reverse order to get the largest palindrome
    for i in length(A):-1:1
        a = A[i]
        if ispalindrome(a[end])
            return (ntuple(j -> a[j], length(a) - 1)..., a[end])
        end
    end
    
    return ntuple(0, m + 1) # default to zero as answer for type stability
end

for i in 1:4
    println(i, " => ", largest_palindrome(i, 2))
end

@assert ispalindrome(9009)
@assert largest_palindrome(2, 2) == (91, 99, 9009)
@assert largest_palindrome(3, 2) == (913, 993, 906609)
