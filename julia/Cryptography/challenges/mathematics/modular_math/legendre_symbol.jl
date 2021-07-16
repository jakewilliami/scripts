function legendre_symbol(a::Integer, p::Integer)
    isodd(p) || error("Cannot use this function on even prime p") # p == 2
    res = mod(a ^ ((p - 1) / 2), p)
    if isone(res) && !iszero(mod(a, p))
        return true
    elseif iszero(res)
        return nothing
    elseif res == -1
        return false
    else
        return nothing
    end
end

function legendresymbol(a::Integer, b::Integer)
    ba = Ref{BigInt}(a)
    bb = Ref{BigInt}(b)
    return ccall((:__gmpz_legendre, :libgmp), Cint, (Ref{BigInt}, Ref{BigInt}), ba, bb)
end

include("output.txt")
for i in ints
    println(isone(legendresymbol(i, p)) ? i : nothing)
    # println(typeof(mod(big(i) ^ big((p - 1) ÷ 2), p)))
end
