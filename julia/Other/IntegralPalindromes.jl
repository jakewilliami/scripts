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
Largest palindrome from the product of 2 `n`-digit numbers
for example, the largest palindrome from the product of 2-digit numbers
is 91 × 99 == 9009
"""
function largest_palindrome(n::Int)
    upper = 10^n - 1
    lower = 10^(n - 1)
    a, b, ans = (0, 0, 0)
    for i in upper:-1:lower
        for j in upper:-1:lower
            _prod = i * j
            if ispalindrome(_prod) && _prod > ans
                a = i
                b = j
                ans = _prod
            end
        end
    end
    return (a, b, ans)
end

for i in 1:4
    println(i, " => ", largest_palindrome(i))
end

@assert ispalindrome(9009)
@assert largest_palindrome(2) == (99, 91, 9009)
@assert last(largest_palindrome(3)) == 906609
