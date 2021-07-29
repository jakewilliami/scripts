using ClassicalCiphers, Combinatorics

include(joinpath(homedir(), "projects", "scripts", "julia", "Other", "Words.jl", "src", "Anagrams.jl"))
include(joinpath(homedir(), "projects", "scripts", "julia", "Cryptography", "GetVigenereKey.jl"))

function print_results(str::String)
	println("Result from best guess at a Caesar shift:")
	caesar_res = crack_caesar(str)
	println("$(caesar_res)\n")
	
	println("Result from best guess at a substitution (monoalphabetic) cipher:")
	monoalphabetic_res = crack_monoalphabetic(str)
	println("$(monoalphabetic_res)\n")
	
	println("Result from best guess at a Affine cipher:")
	affine_res = crack_affine(str)
	println("$(affine_res)\n")
	
	println("Result from best guess at a Vigenere cipher:")
	vigenere_res = crack_vigenere(str)
	println("$(vigenere_res)\n")
end

function main()
    axolotyl = ['L', 'M', 'V', 'C', 'C', 'I', 'B', 'K', 'X']
    wordlist = readlines(joinpath(homedir(), "projects", "scripts", "julia", "Other", "Words.jl", "src", "wordlist.txt"))
    
	# for str in join.(collect(combinations(axolotyl)))
    for str in join.(collect(permutations(axolotyl)))
        # println("Trying \"$str\"")
		caesar_res = crack_caesar(str)
        monoalphabetic_res = crack_monoalphabetic(str)
        affine_res = crack_affine(str)
        vigenere_res = crack_vigenere(str)
        if caesar_res ∈ wordlist
            println("Result from best guess at a Caesar shift:\n$(caesar_res)\n")
        end
        if monoalphabetic_res ∈ wordlist
            println("Result from best guess at a monoalphabetic cipher:\n$(monoalphabetic_res)\n")
        end
        if affine_res ∈ wordlist
            println("Result from best guess at an Affine cipher:\n$(affine_res)\n")
        end
        if vigenere_res ∈ wordlist
            println("Result from best guess at a Vigenere cipher:\n$(vigenere_res)\n")
        end
        # anagram_res = make_anagram(str, wordlist)
        # !isnothing(anagram_res) && println("\"$str\" is an anagram of \"anagram_res\"")
    end
    return nothing     
end

# main()

function main2()
    axolotyl = join(['L', 'M', 'V', 'C', 'C', 'I', 'B', 'K', 'X'])
    wordlist = readlines(joinpath(homedir(), "projects", "scripts", "julia", "Other", "Words.jl", "src", "wordlist.txt"))
    for w in wordlist
        push!(wordlist, w * 's')
    end
    for w in wordlist
        possible_plaintext = decrypt_vigenere(axolotyl, w)
        if possible_plaintext ∈ wordlist
            println("Decrypted to \"$possible_plaintext\" with key \"$w\"")
        end
    end
end

# main2()

function main3()
    axolotyl = ['L', 'M', 'V', 'C', 'C', 'I', 'B', 'K', 'X']
    wordlist = readlines(joinpath(homedir(), "projects", "scripts", "julia", "Other", "Words.jl", "src", "wordlist.txt"))
    for str in lowercase.(join.(collect(permutations(axolotyl))))
        possible_key = get_vigenere_key("asteroids", str)
        if possible_key ∈ wordlist
            println("Found possible key: \"$possible_key\"")
        end
    end
end

main3()
