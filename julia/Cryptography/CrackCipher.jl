using ClassicalCiphers
using Combinatorics

# https://www.thephoenixsociety.org/hl/puzzlesolving.htm
# https://www.thephoenixsociety.org/cryptogram.html
# https://www.thephoenixsociety.org/hl/headline-puzzle.txt
# http://andrewnorman.uk/headline-puzzle/

# str = join(ARGS[1:end], " ")
function main(str)
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

headlines = [
	"AMHXZLX ALXNSTXO APYBX NLJXHXK LI ZJL AHWHMHBX BHUAUBIZ",
	"GHDMRJGB MCGHE CKXCDMCQH SP RLCEE OSEE, ZHMCGHE MSU DJCC EOSM",
	"WYNAJSM PYXMKANWAJKANB VNYLXPA MAFN-VANWAPK CXMLNAL LYQQFN IJQQB",
	"XOAJRH DOHU XFNIRA MPS GRNC RBQTSPBIRBHNF FNG RBMPSDRIRBH",
	"FRHRXIQ ALVTURXF RQX. VALPPF SI VXCMRLP XLVJ LPFPVLXU"
]

words = readlines("../Other/Words.jl/src/wordlist.txt")

for (i, headline) in enumerate(headlines)
	@info "Processing headline $i: \"$headline\""
	# main(headline)
	# println(); println()
	for p in permutations('A':'Z')
		# monoalphabetic_res = crack_monoalphabetic(headline)
		monoalphabetic_res = decrypt_monoalphabetic(headline, join(p))
		if count(i -> i ∈ words, split(monoalphabetic_res)) > 2
			@info "Found match!: \"$monoalphabetic_res\""
            break
   		end
	end
end
