function ispalindrome(str::AbstractString)
    return str == reverse(str)
end
