function first_attempt(S::String)
    str_odd_len = isodd(length(S))
    
    rev_S = reverse(S)
    left_diag = S[1:(length(S) ÷ 2)]
    left_diag = left_diag * reverse(left_diag)
    right_diag = S[((length(S) ÷ 2) + (str_odd_len ? 2 : 1)):end]
    right_diag = right_diag * reverse(right_diag)

    println(left_diag)
    println(right_diag)

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
            n_edge_spaces = g(i, length(S)) - 1
            edge_spaces = " " ^ n_edge_spaces
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

function construct_fun_crisscross(S::String)
    function g(n::Integer, l::Integer)
        rat = ((l + 1)//2)
        res = rat - abs(n - rat)
        res.den != 1 && error("Oh dear, we have a float; an unfortunate thing for an index to be")
        return res.num
    end
    
    str_odd_len = isodd(length(S))
    
    rev_S = reverse(S)
    left_diag = S[1:(length(S) ÷ 2)]
    left_diag = left_diag * reverse(left_diag)
    right_diag = S[((length(S) ÷ 2) + (str_odd_len ? 2 : 1)):end]
    right_diag = right_diag * reverse(right_diag)

    out = String[S]

    for (i, j) in enumerate(2:(length(S) - 1))
        this_row = fill(' ', length(S))
        
        this_row[1] = S[j]
        this_row[length(S)] = rev_S[j]
        this_row[g(j, length(S))] = S[j]
        this_row[length(S) - g(j, length(S)) + 1] = rev_S[j]
        
        push!(out, join(this_row))
    end

    push!(out, rev_S)

    return out
end


function main()
    for s in ARGS
        for l in construct_fun_crisscross(s)
            println(l)
        end

        println()
    end
end

main()
