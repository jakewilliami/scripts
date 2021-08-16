function euclideans_algorithm(a::Integer, b::Integer)
    if a < b
        a, b = (b, a)
    end
    
    while !iszero(b)
        r = mod(a, b)
        a = b
        b = r
    end
    
    return a
end

println(euclideans_algorithm(66528, 52920))
println(euclideans_algorithm(66528, 52920) == gcd(66528, 52920))

