#!/usr/bin/env bash
    #=
    exec julia --project="~/scripts/julia/Cryptography/" "${BASH_SOURCE[0]}" "$@" -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#
"""
	e.g., ./Affine.jl "olwreglfelehnjjhmehlos" 7 5 27 d

	e.g., ./Affine.jl "maryhadalittlelamb" 19 5 26 e
"""

plaintext = ARGS[1]
ciphertext = ARGS[1]
a = parse(Int, ARGS[2])
b = parse(Int, ARGS[3])
m = parse(Int, ARGS[4])
cryptType = ARGS[5]

if isequal(m, 26)
	dict = Dict{String, Integer}("a" => 0, "b" => 1, "c" => 2, "d" => 3, "e" => 4, "f" => 5, "g" => 6, "h" => 7, "i" => 8, "j" => 9, "k" => 10, "l" => 11, "m" => 12, "n" => 13, "o" => 14, "p" => 15, "q" => 16, "r" => 17, "s" => 18, "t" => 19, "u" => 20, "v" => 21, "w" => 22, "x" => 23, "y" => 24, "z" => 25)
elseif isequal(m, 27)
	global dict = Dict{String, Integer}(" " => 0, "a" => 1, "b" => 2, "c" => 3, "d" => 4, "e" => 5, "f" => 6, "g" => 7, "h" => 8, "i" => 9, "j" => 10, "k" => 11, "l" => 12, "m" => 13, "n" => 14, "o" => 15, "p" => 16, "q" => 17, "r" => 18, "s" => 19, "t" => 20, "u" => 21, "v" => 22, "w" => 23, "x" => 24, "y" => 25, "z" => 26)
else
	global dict = Dict{String, Integer}("a" => 0, "b" => 1, "c" => 2, "d" => 3, "e" => 4, "f" => 5, "g" => 6, "h" => 7, "i" => 8, "j" => 9, "k" => 10, "l" => 11, "m" => 12, "n" => 13, "o" => 14, "p" => 15, "q" => 16, "r" => 17, "s" => 18, "t" => 19, "u" => 20, "v" => 21, "w" => 22, "x" => 23, "y" => 24, "z" => 25)
end


function encryptAffine(plaintext::AbstractString, a::Integer, b::Integer)

	encryptedAlphaVec = Vector()
	encryptedArabVec = Vector()

	for character in split(plaintext, "")
		encryptedArabChar = mod(get(dict, character, 0)*a + b, length(dict)) # mod(ax + b, m)
		encryptedArabVec = vcat(encryptedArabVec, encryptedArabChar)
	end

	for encryptedKey in encryptedArabVec
		encryptedAlphaVec = vcat(encryptedAlphaVec, findfirst(==(encryptedKey), dict))
	end

	return join(encryptedAlphaVec)
end

function decryptAffine(ciphertext::AbstractString, a::Integer, b::Integer)
	# invmod(a)(f(x) - b) = x
	decryptedAlphaVec = Vector()
	decryptedArabVec = Vector()

	for character in split(ciphertext, "")
		decryptedArabChar = mod(invmod(a, length(dict)) * (get(dict, character, 0) - b), length(dict))
		decryptedArabVec = vcat(decryptedArabVec, findfirst(==(decryptedArabChar), dict))
	end

	return join(decryptedArabVec)

end


if cryptType == "e"
	println(encryptAffine(plaintext, a, b))
elseif cryptType == "d"
	println(decryptAffine(ciphertext, a, b))
else
	error("Specify *cryption type: either `d` or `e`.")
end
