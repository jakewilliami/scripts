#!/usr/bin/env bash
    #=
    exec julia --project="~/scripts/julia/Cryptography/" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#
"""
	e.g., ./Vigenere.jl "paperbackwriter" "paul" e

	e.g., ./Vigenere.jl "xjtwzgvzx" "eve" d
	
	e.g., ./Vigenere.jl "paperbackwriter" "eajpgbunzwltiel" f
"""

using Base.Iterators # for repeating key

plaintext = ARGS[1]
ciphertext = ARGS[1]
key = ARGS[2]
cryptType = ARGS[3]
m = ARGS[4] # determines dictionary used

if isequal(m, 26)
	dict = Dict{String, Integer}("a" => 0, "b" => 1, "c" => 2, "d" => 3, "e" => 4, "f" => 5, "g" => 6, "h" => 7, "i" => 8, "j" => 9, "k" => 10, "l" => 11, "m" => 12, "n" => 13, "o" => 14, "p" => 15, "q" => 16, "r" => 17, "s" => 18, "t" => 19, "u" => 20, "v" => 21, "w" => 22, "x" => 23, "y" => 24, "z" => 25)
elseif isequal(m, 27)
	global dict = Dict{String, Integer}(" " => 0, "a" => 1, "b" => 2, "c" => 3, "d" => 4, "e" => 5, "f" => 6, "g" => 7, "h" => 8, "i" => 9, "j" => 10, "k" => 11, "l" => 12, "m" => 13, "n" => 14, "o" => 15, "p" => 16, "q" => 17, "r" => 18, "s" => 19, "t" => 20, "u" => 21, "v" => 22, "w" => 23, "x" => 24, "y" => 25, "z" => 26)
else
	global dict = Dict{String, Integer}("a" => 0, "b" => 1, "c" => 2, "d" => 3, "e" => 4, "f" => 5, "g" => 6, "h" => 7, "i" => 8, "j" => 9, "k" => 10, "l" => 11, "m" => 12, "n" => 13, "o" => 14, "p" => 15, "q" => 16, "r" => 17, "s" => 18, "t" => 19, "u" => 20, "v" => 21, "w" => 22, "x" => 23, "y" => 24, "z" => 25)
end


function encryptVigenere(plaintext::AbstractString, key::AbstractString)

	encryptedAlphaVec = Vector()
	encryptedArabVec = Vector()
	keyVec = Vector()

	for character in split(plaintext, "")
		encryptedArabChar = get(dict, character, 0)
		encryptedArabVec = vcat(encryptedArabVec, encryptedArabChar)
	end
	
	# split key into numbers
	for keyChar in split(key, "")
		keyArabChar = get(dict, keyChar, 0)
		keyVec = vcat(keyVec, keyArabChar)
	end
	
	# repeat key number of times required
	keyVec = collect(take(flatten(repeated(keyVec)), length(plaintext)))
	
	encryptedArabVec = mod.(encryptedArabVec .+ keyVec, length(dict))

	for encryptedKey in encryptedArabVec
		encryptedAlphaVec = vcat(encryptedAlphaVec, findfirst(==(encryptedKey), dict))
	end
	
	return join(encryptedAlphaVec)
end

function decryptVigenere(ciphertext::AbstractString, key::AbstractString)
	decryptedAlphaVec = Vector()
	decryptedArabVec = Vector()
	keyVec = Vector()
	
	# split key into numbers
	for keyChar in split(key, "")
		keyArabChar = get(dict, keyChar, 0)
		keyVec = vcat(keyVec, keyArabChar)
	end
	
	# repeat key number of times required
	keyVec = collect(take(flatten(repeated(keyVec)), length(ciphertext)))


	counter = 0
	for character in split(ciphertext, "")
		counter = counter + 1
		decryptedArabChar = mod(get(dict, character, 0) - keyVec[counter], length(dict))
		decryptedArabVec = vcat(decryptedArabVec, findfirst(==(decryptedArabChar), dict))
	end
	
	return join(decryptedArabVec)

end


function findKey(plaintext::AbstractString, ciphertext::AbstractString)
	encryptedAlphaVec = Vector()
	encryptedArabVec = Vector()
	decryptedAlphaVec = Vector()
	decryptedArabVec = Vector()
	keyVec = Vector()
	decryptedKeyVec = Vector()

	for character in split(plaintext, "")
		encryptedArabChar = get(dict, character, 0)
		encryptedArabVec = vcat(encryptedArabVec, encryptedArabChar)
	end
	
	# split key into numbers
	for keyChar in split(key, "")
		keyArabChar = get(dict, keyChar, 0)
		keyVec = vcat(keyVec, keyArabChar)
	end
	
	# repeat key number of times required
	keyVec = collect(take(flatten(repeated(keyVec)), length(plaintext)))
	
	# get ciphertext
	for character in split(ciphertext, "")
		decryptedArabChar = mod(get(dict, character, 0), length(dict))
		decryptedArabVec = vcat(decryptedArabVec, decryptedArabChar)
	end
	
	# find key
	keyVec = mod.(decryptedArabVec .- encryptedArabVec, length(dict))
	
	# parse key vector back into letters
	for digit in keyVec
		decryptedKeyChar = findfirst(==(digit), dict)
		decryptedKeyVec = vcat(decryptedKeyVec, decryptedKeyChar)
	end
	
	return join(decryptedKeyVec)
end


if cryptType == "e"
	println(encryptVigenere(plaintext, key))
elseif cryptType == "d"
	println(decryptVigenere(ciphertext, key))
elseif cryptType == "f"
	plaintext = ARGS[1]
	ciphertext = ARGS[2]
	println(findKey(plaintext, ciphertext))
else
	error("Specify *cryption type: either `d` or `e` or `f`.")
end
