export LONGEST_PALINDROME

const LONGEST_PALINDROME = "tattarrattat"

function ispalindrome(str::AbstractString)
    return str == reverse(str)
end
