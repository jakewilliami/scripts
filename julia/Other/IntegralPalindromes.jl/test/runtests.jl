using IntegralPalindromes
using Test

@testset "IntegralPalindromes.jl" begin
    @test ispalindrome(9009)
    @test ispalindrome(big(12345678900987654321))
    @test largest_palindrome(2, 2) == (91, 99, 9009)
    @test largest_palindrome(3, 2) == (913, 993, 906609)
end
