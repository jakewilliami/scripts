function modulo_inverse(a::Integer, m::Integer)
    g, x, y = gcdx(a, m)
	if isone(g)
		return mod(x, m)
	else
        error("Modulo inverse of ", a, " modulo ", m, " does not exist")
		return nothing
	end
end

a, m = (3, 13)
println("The multiplicative inverse of ", a, " modulo ", m, " is:")
println(modulo_inverse(a, m))
