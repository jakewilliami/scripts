function closest_square_brute_force(n::UInt)
    sqrt_n = sqrt(n)
    if isinteger(sqrt_n)
        return round(Int, sqrt_n)
    end
    direction = rem(sqrt_n, one(sqrt_n)) > 0.5 ? 1 : -1
    i = 1
    while true
        new_n = n + (i * direction)
        if isinteger(sqrt(new_n))
            return round(Int, new_n)
        end
        i += 1
    end
end

function closest_square(n::UInt)
    sqrt_n = sqrt(n)
    if isinteger(sqrt_n)
        return convert(Int, sqrt_n)
    end
    return round(Int, sqrt_n)^2
end

for f in (:closest_square_brute_force, :closest_square)
    @eval begin
        function $f(n::Int)
            if n < 0
                @warn "Your input is negative; converting to a positive value"
                n = abs(n)
            end
            return $f(n)
        end
    end
end
