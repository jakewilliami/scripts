# p = 29
# a = 11
# a^2 = 5 mod 29 => √5 = 11 mod 29
# we say that an integer x is a Quadratic Residue if there exists an a such that a^2 = x mod p. If there is no such solution, then the integer is a Quadratic Non-Residue.
function quadratic_residues(x::Integer, p::Integer)
    for a in 1:(p - 1)
        if mod(a^2, p) == x
            return a
        end
    end
    
    return nothing
end

# println(quadratic_residues(5, 29))
# println(quadratic_residues(18, 29))
for i in [14, 6, 11]
    println(quadratic_residues(i, 29))
end
