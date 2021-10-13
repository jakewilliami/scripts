using IntegralPalindromes
using Test

@testset "IntegralPalindromes.jl" begin
    @test ispalindrome(9009)
    @test ispalindrome(big(12345678900987654321))
    @test largest_palindrome(2, 2) == (91, 99, 9009)
    @test largest_palindrome(3, 2) == (913, 993, 906609)
end

@testset "Iterator" begin
    R = 1:5
    m = 2
    @test all(last(i) == last(j) for (i, j) in zip(ProdIter2(R.start, R.stop), IntegralPalindromes._prod_iter(R.start, R.stop, m)))
end
