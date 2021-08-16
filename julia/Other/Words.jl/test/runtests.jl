include(joinpath(dirname(@__DIR__), "src", "Words.jl"))
using .Words, Tests

@testset "Palindromes" begin
    @test ispalindrome("anna")
    @test ispalindrom(LONGEST_PALINDROME)
end

@testset "Anagrams" begin
    @test isanagram("anna", "nana")
    @test get_anagram_map("anna", "nana") == Dict(('n', 2) => 1, ('a', 4) => 1, ('a', 1) => 2, ('n', 3) => 1)
    @test get_anagram_map("abcd", "adbc") == Dict(('a', 1) => 1, ('d', 4) => 1, ('b', 2) => 2, ('c', 3) => 2)
end

@testset "Acrostics and Abecadarii (?)" begin
    @test abecedarius("and big cats don't envy frogs") == (true, 1, "abcdef", :left)
    @test abecedarius("lkjhgfdsaand asdfghjklbig lkjhgfdsacats asdfghjkldon't lkjhgfdsaenvy asdfghjklfrogs") == (true, 10, "abcdef", :left)
    @test abecedarius(reverse.(split("and big cats don't envy frogs", ' '))) == (true, 1, "abcdef", :right)
    @test abecedarius("dna gib stac t'nod yvne sgorf") == (true, 1, "abcdef", :right)
end
