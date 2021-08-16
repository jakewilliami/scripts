hexstr = "0e0b213f26041e480b26217f27342e175d0e070a3c5b103e2526217f27342e175d0e077e263451150104"
bytes = hex2bytes(hexstr)

start_of_flag = codeunits("crypto{")

function get_bitwise_string(B1::V1, B2::V2) where {V1, V2 <: Union{Vector{UInt8}, Base.CodeUnits{UInt8, String}}}
    return String([b1 ⊻ b2 for (b1, b2) in zip(B1[1:length(B2)], B2)])
end

key_start = get_bitwise_string(bytes, start_of_flag)

# key_start is currently "myXORke".  I wonder what the next letter will be 🙃
key = key_start * 'y'
# just repeat the key over the length of the ciphertext
key *= key ^ ((length(bytes) - length(key)) ÷ length(key))
key *= key[1:(mod((length(bytes) - length(key)), length(key)))]

# get the flag with the code units of the key you found
flag = get_bitwise_string(bytes, codeunits(key))
println(flag)
