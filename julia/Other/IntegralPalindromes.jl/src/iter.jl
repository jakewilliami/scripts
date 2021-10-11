using Combinatorics
using ResumableFunctions

struct ProdIter
    lower::Int
    upper::Int
    m::Int
end

struct ProdIter2
    lower::Int
    upper::Int
    lower_bound::Int
    function ProdIter2(lower::Int, upper::Int, lower_bound::Int)
        @assert lower_bound == (lower - 1) "The boundaries of this iterator must be [lower, upper] or (lower_bound, upper]"
        return new(lower, upper, lower_bound)
    end
end
ProdIter2(lower::Int, upper::Int) = ProdIter2(lower, upper, lower - 1)

function Base.iterate(iter::ProdIter, state = (ntuple(iter.upper, iter.m)..., iter.upper^m, NTuple{iter.m + 1, Int}[]))
    xs = ntuple(i -> state[i], m)
    
    if all(x > upper for x in xs)
        return nothing
    end
end

# Base case
Base.iterate(iter::ProdIter2) = 
    ((iter.upper, iter.upper, iter.upper^2), ((iter.upper, iter.upper), iter.upper^2, NTuple{3, Int}[]))

# Induction step
function Base.iterate(iter::ProdIter2, state::Tuple{NTuple{2, Int}, Int, Vector{NTuple{3, Int}}}) # the state has ((xs...), prod, queue)
    a, b = first(state)
    _, product, queue = state
    
    # stop if either value is
    # if xor(((i - 1) == 0 for i in state[1:iter.m])...)
    # if (a - 1) == 0 ⊻ (b - 1) == 0
    # if xor(((i - 1) == 0 for i in first(state))...)
    # if (a-1) == (iter.lower-1) ⊻ (b-1) == (iter.lower-1)
    # if (a-1) == (iter.lower-1) ⊻ (b-1) == (iter.lower-1)
    # if (a-1 == iter.lower-1) && (b-1 == iter.lower-1)
    if all((i - 1) == iter.lower_bound for i in first(state))
    # if xor(((i - 1) == 0 for i in [a, b])...)
    # if xor((b - 1) == 0, (a - 1) == 0)
    # if (a == 0 ⊻ b == 0) && !(a == 0 && b == 0)
    # if ((a - 1) == 0) ⊻ ((b - 1) == 0)
        return nothing
    end
    
    c = (a - 1)b
    d = (b - 1)a
    
    for (k, item) in enumerate(queue)
        i, j, qprod = item
        if qprod > c || qprod > d
            deleteat!(queue, k)
            return (i, j, qprod), ((i, j), qprod, queue)
        end
    end
    if c > d
        return (a - 1, b, c), ((a - 1, b), c, push!(queue, (a, b - 1, d)))
    else
        return (a, b - 1, d), ((a, b - 1), d, push!(queue, (a - 1, b, c)))
    end
end


Base.eltype(iter::ProdIter) = NTuple{iter.m, Int}
# Base.length(iter::ProdIter) = sum(1:(iter.upper - iter.lower + 1))
# Base.length(iter::ProdIter) = (iter.n * (iter.n + iter.m − 1)) ÷ iter.m

Base.eltype(iter::ProdIter2) = NTuple{iter.m, Int}
# Base.length(iter::ProdIter2) = sum(1:(iter.upper - iter.lower + 1))

function reviter(lower::Int, upper::Int, m::Int)
    # sort!([a for a in Combinatorics.with_replacement_combinations(lower:upper, m)], by = prod, rev = true)
    A = collect(Combinatorics.multiset_permutations(1:5, 2))
    for i in lower:upper
        push!(A, [i, i])
    end
    A = [vcat(a, prod(a)) for a in A]
    return sort!(A, by = last, rev = true)
end

for (i, j) in zip(ProdIter2(1, 5), reviter(1, 5, 2))
    println(i, " — ", j)
end

#=
@resumable function rev_iter(lower::Int, upper::Int, m::Int)
    if m < 1
        return nothing
    elseif m == 1
        for i in lower:upper
            @yield (i, )
        end
    end
    
    for i in lower:upper
        for n in rev_iter(lower, upper, m - 1)
            @yield (i, n...)
        end
    end
    return nothing
end

for i in rev_iter(1, 5, 2)
    println(i)
end
=#
