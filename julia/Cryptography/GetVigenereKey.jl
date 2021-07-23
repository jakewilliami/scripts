"""
Returns a substring if repeating perfectly, e.g.
```julia
"abcabc" -> "abc"
"abcabca" -> nothing
```
"""
function _repeated_substring(source)
	len = length(source)
    
	# had to account for weird edge case in which length 2 vectors always returns themselves
	if len < 3
		len == 1 && return nothing

		s1, s2 = source
		if len == 2 && s1 == s2
			return s1
		else
			return nothing
		end
	end

	# Check candidate strings
	for i in 1:(len ÷ 2 + 1)
		repeat_count, remainder = divrem(len, i)

		# Check for no leftovers characters, and equality when repeated
		if remainder == 0 && source == repeat(source[1:i], repeat_count)
			return source[1:i]#, repeat_count
		end
	end

	return nothing
end

"""
Returns a repeated substring, even if the final substring isn't finished.  E.g.,
```julia
"abcabc" -> "abc"
"abcabca" -> "abc" # the final 'a' starts the substring again
"abacba" -> "abacba"
```
"""
function repeated_substring(source)
    for i in length(source):-1:1
        possible_repeating_substring = _repeated_substring(source[1:i])
        !isnothing(possible_repeating_substring) && return possible_repeating_substring
    end
    
    return source
end

function get_vigenere_key(plaintext::AbstractString, ciphertext::AbstractString)
    io = IOBuffer()
    for (p, c) in zip(plaintext, ciphertext)
        print(io, Char(abs(mod(c - p, 26) + 97)))
    end
    res = String(take!(io))
    return repeated_substring(res)
end
