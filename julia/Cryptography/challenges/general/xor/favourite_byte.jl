hexstr = "73626960647f6b206821204f21254f7d694f7624662065622127234f726927756d"
bytes = hex2bytes(hexstr)
flag_fmt = r"crypto\{.*\}"

for i in 1:typemax(UInt8) # answer was i = 16
    potential_flag = String([b ⊻ UInt8(i) for b in bytes])
    if occursin(flag_fmt, potential_flag)
        println(i, ":\t", potential_flag)
    end
end
