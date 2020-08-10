#!/usr/bin/env bash
    #=
    exec julia --project="~/scripts/julia/Cryptography/" "${BASH_SOURCE[0]}" "$@" -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#
"""
	e.g., ./Caesar.jl "khoorzruog" 3 d

	e.g., ./Caesar.jl "maryhadalittlelamb" 6 e
"""

plaintext = ARGS[1]
ciphertext = ARGS[1]
shift = parse(Int64, ARGS[2])
cryptType = ARGS[3]
m = ARGS[4] # determines dictionary used


if isequal(m, 26)
	dict = Dict{String, Integer}("a" => 0, "b" => 1, "c" => 2, "d" => 3, "e" => 4, "f" => 5, "g" => 6, "h" => 7, "i" => 8, "j" => 9, "k" => 10, "l" => 11, "m" => 12, "n" => 13, "o" => 14, "p" => 15, "q" => 16, "r" => 17, "s" => 18, "t" => 19, "u" => 20, "v" => 21, "w" => 22, "x" => 23, "y" => 24, "z" => 25)
elseif isequal(m, 27)
	global dict = Dict{String, Integer}(" " => 0, "a" => 1, "b" => 2, "c" => 3, "d" => 4, "e" => 5, "f" => 6, "g" => 7, "h" => 8, "i" => 9, "j" => 10, "k" => 11, "l" => 12, "m" => 13, "n" => 14, "o" => 15, "p" => 16, "q" => 17, "r" => 18, "s" => 19, "t" => 20, "u" => 21, "v" => 22, "w" => 23, "x" => 24, "y" => 25, "z" => 26)
else # fall back on standard alphabet
	global dict = Dict{String, Integer}("a" => 0, "b" => 1, "c" => 2, "d" => 3, "e" => 4, "f" => 5, "g" => 6, "h" => 7, "i" => 8, "j" => 9, "k" => 10, "l" => 11, "m" => 12, "n" => 13, "o" => 14, "p" => 15, "q" => 16, "r" => 17, "s" => 18, "t" => 19, "u" => 20, "v" => 21, "w" => 22, "x" => 23, "y" => 24, "z" => 25)
end


function encryptCaesar(plaintext::AbstractString, shift::Integer)

	global encryptedAlphaVec = Vector()
	global encryptedArabVec = Vector()

	for character in split(plaintext, "")
		encryptedArabChar = mod(get(dict, character, 0) + shift, length(dict))
		encryptedArabVec = vcat(encryptedArabVec, encryptedArabChar)
	end

	for encryptedKey in encryptedArabVec
		encryptedAlphaVec = vcat(encryptedAlphaVec, findfirst(==(encryptedKey), dict))
	end

	return join(encryptedAlphaVec)
end

function decryptCaesar(ciphertext::AbstractString, shift::Integer)
	global decryptedAlphaVec = Vector()
	global decryptedArabVec = Vector()

	for character in split(ciphertext, "")
		decryptedArabChar = mod(get(dict, character, 0) - shift, length(dict))
		decryptedArabVec = vcat(decryptedArabVec, findfirst(==(decryptedArabChar), dict))
	end
	
	return join(decryptedArabVec)

end


if cryptType == "e"
	println(encryptCaesar(plaintext, shift))
elseif cryptType == "d"
	println(decryptCaesar(ciphertext, shift))
else
	error("Specify *cryption type: either `d` or `e`.")
end
