function extended_gcd(a::Integer, b::Integer, x::Integer = 0, y::Integer = 0)
	if iszero(a)
		x = 0
		y = 1
		return b, x, y
    end
    
	b_div_a, b_mod_a = divrem(b, a)
    g, x, y = extended_gcd(b_mod_a, a)
    
    return g, (y - b_div_a * x), x
end

println(extended_gcd(26513, 32321))
println(extended_gcd(26513, 32321) == gcdx(26513, 32321))
