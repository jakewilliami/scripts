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
