using RomanNumerals, OrderedCollections, Suppressor, Plots

function construct_length_distribution_map(lower::Integer, upper::Integer)
    hashmap = OrderedDict{RomanNumeral, Integer}()
    for i in lower:upper
        r = RomanNumeral(i)
        hashmap[r] = length(r.str)
    end
    
    return hashmap
end
construct_length_distribution_map(upper::Integer) = construct_length_distribution_map(1, upper)

function main(hashmap::OrderedDict{RomanNumeral, Integer})
    numbers = Integer[r.val for r in keys(hashmap)]
    lengths = BigInt[round(BigInt, v) for v in values(hashmap)]
    plt = plot(numbers, lengths, label = false, xlabel = "Number", ylabel = "Length of corresponding roman numeral")
    out_path = "roman_numeral_length_dist.pdf"
    savefig(plt, out_path)
    return out_path
end
main(A::Integer...) = main(construct_length_distribution_map(A...))

@suppress begin # suppress large RomanNumeral warning
    global hashmap = construct_length_distribution_map(100_000)
    main(hashmap)
end
