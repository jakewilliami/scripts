# You read binary numbers from right to left.
# Starting at the far right, our multiplier is one.  We use this multiplier on the number we are reading.  For example, "010" would start by multiplying 0 by 1.
# We move left one place, thus multiplying our multiplier by 2.  So our multiplier is now 2.  We multiply that with the new number we are reading, and add the result to the previous result.  For example, "010" would next be reading 1 and multiplying that by 2 (which is the number 2), and then adding the previous result (zero).  This continues, so our final result for this example will be 2.
function parsebin(binstr::AbstractString)
    res = 0
    mult = 1
    for i in length(binstr):-1:1
        binchar = binstr[i]
        res += mult * (binchar == '1' ? 1 : 0)
        mult *= 2
    end
    return res
end

# Alternatively, which *may* save time in some cases
#=
function parsebin(binstr::AbstractString)
    res = 0
    mult = 1
    for i in length(binstr):-1:1
        binchar = binstr[i]
        if binchar == '1'
            res += mult
        end
        mult *= 2
    end
    return res
end
=#

# You can also do this inline
parsebin2(binstr::AbstractString) = sum((2 ^ (i - 1)) * (binstr[j] == '1' ? 1 : 0) for (i, j) in enumerate(length(binstr):-1:1))
