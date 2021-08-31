export Initials, find_initial_equivalences

"""
```julia
struct Initials
    initials::NTuple{N, Char} where {N}
end
Initials(I::Char...)
Initials(name::String)
```
Initials are ensured to be uppercase.
"""
struct Initials
    initials::NTuple{N, Char} where {N}
    function Initials(initials::NTuple{N, Char}) where {N}
        # ensure initials are uppercase
        new(tuple((uppercase(c) for c in initials)...))
    end
end
Initials(I::Char...) = Initials(I)
Initials(name::String) = Initials(tuple((uppercase(s[1]) for s in split(name, ' '))...))
Base.length(I::Initials) = length(I.initials)

"""
```julia
find_initial_equivalences(I::Initials) -> Vector{Initials}
find_initial_equivalences(I::Char...) -> Vector{Initials}
```
Find numerically equivalent initials, where 'A' => c, 'B' => 1 + c, ..., 'Z' => 26 + c.
For example, the initials `('A', 'A')` (i.e., 1 + 1) has only one way to sum, so its equivalent initials are empty.  However, the initials `('A', 'C')` has two equivalences: itself reversed—`('C', 'A')`—, and `('B', 'B')`.
"""
function find_initial_equivalences(I::Initials)
    equivalences = Initials[]
    numerical_I = sum(Int(c) - 65 for c in I.initials)
    for i in Base.Iterators.product((0:25 for _ in 1:length(I))...)
        if numerical_I == sum(i)
            new_I = Initials((Char(j + 65) for j in i)...)
            new_I.initials != I.initials && push!(equivalences, new_I)
        end
    end
    return equivalences
end
find_initial_equivalences(I::Char)
