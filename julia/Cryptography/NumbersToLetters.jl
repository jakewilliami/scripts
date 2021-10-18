using Combinatorics

"""
```julia
numbers_to_letters(n::Integer)
```
This function converts a number into a series of characters.

For example, if we map `1 => a`, `2 => b`, and so on, then giving this function the number `123` will return `"abc"` (i.e., by having characters `[1, 2, 3]`.

However, the number `123` can be parsed as having the characters `[12, 3]`, and `[1, 23]`.  However, the number `678` can only be parsed in one way: `[6, 7, 8]`, as the numbers `67` and `78` are out of the range of the standard alphabet.
"""
function numbers_to_letters(n::Integer)
    _digits = reverse(digits(n))
    _ndigits = length(_digits)
    res = String[]
    
    opts = Vector{Int}[]
    C = [c for c in combinations(_digits) if length(c) ≤ 2]
    C_first = [c[1] for c in C]
    for (i, d) in enumerate(_digits)
        js = findall(==(d), C_first)
        for j in js
            c = C[j]
            # check if this combination is in order of the digits
            if i < _ndigits && length(c) > 1 && c[2] != _digits[i + 1]
                continue
            else
                # then c is in the correct order and is feasible
                push!(opts, c)
            end
        end
    end
    # now if n is 120, opts will be [[1], [1, 2], [2], [2, 0], [0]]
    
    # now we need to sort through opts and find the combinations that work
    C′ = Vector{Vector{Int}}[]
    for i in _ndigits:-1:1
        opt = [c for c in combinations(opts, i) if sum(length(c′) for c′ in c) == _ndigits]
        append!(C′, opt)
    end
    io = IOBuffer()
    res = String[]
    for opt in C′
        valid_opt = all(d1 == d2 for (d1, d2) in zip(_digits, Iterators.flatten(opt))) && all(foldl((r, v) -> 10r + v, c) ≤ 26 for c in opt if length(c) > 1)
        valid_opt || continue
        for i in opt
            k = foldl((r, v) -> 10r + v, i)
            print(io, Char(k + 96))
        end
        push!(res, String(take!(io)))
    end
    
    return res
end

numbers_to_letters(123)
