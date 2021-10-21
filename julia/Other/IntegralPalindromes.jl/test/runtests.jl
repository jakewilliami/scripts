using IntegralPalindromes
using Test

@testset "IntegralPalindromes.jl" begin
    @test ispalindrome(9009)
    @test ispalindrome(big(12345678900987654321))
    @test largest_palindrome(2, 2) == (91, 99, 9009)
    @test largest_palindrome(3, 2) == (913, 993, 906609)
end

@testset "Iterator" begin
    prod_iter_equals(A, B) = all(last(i) == last(j) for (i, j) in zip(A, B))
    m = 2
    for R in (1:5, 1:100, 50:1000)
        @test prod_iter_equals(ProdIter2(R.start, R.stop), IntegralPalindromes._prod_iter(R.start, R.stop, m))
    end
end

#=
julia> @btime collect(ProdIter2($1, $10));
  27.661 μs (233 allocations: 18.14 KiB)

julia> @btime collect(ProdIter($1, $10, $2));
  48.147 μs (759 allocations: 36.50 KiB)

julia> @btime IntegralPalindromes._prod_iter($1, $10, $2);
  20.710 μs (420 allocations: 44.45 KiB)

julia> @btime collect(ProdIter2($1, $100));
  3.828 ms (19175 allocations: 1.48 MiB)

julia> @btime collect(ProdIter($1, $100, $2));
  5.550 ms (78694 allocations: 3.30 MiB)

julia> @btime IntegralPalindromes._prod_iter($1, $100, $2);
  3.252 ms (40031 allocations: 11.05 MiB)
=#
