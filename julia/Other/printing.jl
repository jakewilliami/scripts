function main(S::String)
    str_odd_len = isodd(length(S))
    
    rev_S = reverse(S)
    left_diag = S[1:(length(S) ÷ 2)]
    left_diag = left_diag * reverse(left_diag)
    right_diag = S[((length(S) ÷ 2) + (str_odd_len ? 2 : 1)):end] ^ 2
    right_diag = right_diag * reverse(right_diag)

    
    out = String[S]
    println(S)
    for (i, j) in enumerate(2:(length(S) - 1))
        first_s = S[j]
        last_s = rev_S[j]

        s = string()
        
        if str_odd_len && j == (length(S) ÷ 2)
            # middle number
            n_edge_spaces = (length(S) ÷ 2) - 2
            edge_spaces = " " ^ n_edge_spaces
            s = first_s * edge_spaces * S[length(S) ÷ 2] * edge_spaces * last_s
        else
            n_edge_spaces = 0
            # 1->0,2->1,3->4,4->4,5->3,6->2...
            if i > (length(S) ÷ 2)
                n_edge_spaces = mod((length(S) ÷ 2) - i, (length(S) ÷ 2)) - 2
            else
                n_edge_spaces = mod(i - 1, (length(S) ÷ 2))
            end
            edge_spaces = " " ^ n_edge_spaces
            # diag_s_start = left_diag[j]
            # diag_s_end = right_diag[j]
            diag_s_start = S[j]
            diag_s_end = rev_S[j]
            n_middle_spaces = length(S) - 4 - (2 * n_edge_spaces)
            middle_spaces = " " ^ abs(n_middle_spaces)
            s = first_s * edge_spaces * first_s * middle_spaces * last_s * edge_spaces * last_s
        end
        println(s)
        # push!(out, s)
    end
    println(rev_S)
    push!(out, rev_S)

    return out
end

main("Programm")
println()
println("""
Programm
rr    mm
o o  a a
g  gr  r
r  rg  g
a a  o o
mm    rr
mmargorP
""")


# 2 -> 2
# 3 -> 3
# 4 -> 4
# 5 -> 4
# 6 -> 3
# 7 -> 2


# for S in ARGS
    # for l in main(S)
        # println(l)
    # end
# end


out2 = """
Programming
rr       nn
o o     i i
g  g   m  m
r   r m   m
a    a    a
m   m r   r
m  m   g  g
i i     o o
nn       rr
gnimmargorP
"""
