using DataStructures
using Combinatorics

# A helper function to enqueue something if and only if it doesn't already exist
_try_enqueue!(pq::PriorityQueue{K, V}, k::K, v::V) where {K, V} = k in keys(pq) ? pq : enqueue!(pq, k, v)

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

Base.iterate(iter::ProdIter2) = 
    ((iter.upper, iter.upper, iter.upper^2), ((iter.upper, iter.upper), iter.upper^2, PriorityQueue{NTuple{2, Int}, Int}(Base.Order.Reverse))) # or Base.Order.Forward, if we wanted to get the lowest element first

# Induction step
# TODO: generalise to m > 2
function Base.iterate(iter::ProdIter2, state::Tuple{NTuple{2, Int}, Int, PriorityQueue{NTuple{2, Int}, Int}}) # the state has ((xs...), prod, queue)
    t, product, pq = state # change product => _ ?
    a, b = t
    
    # stop if either value is
    if ((a - 1) == iter.lower_bound) && ((b - 1) == iter.lower_bound) # all((i - 1) == iter.lower_bound for i in t)
    # if a - 1 == 0 ||
        return nothing
    end
    
    c = (a - 1)b
    d = (b - 1)a

    if !isempty(pq)
        k, qprod = peek(pq)
        if qprod > c || qprod > d # any(qprod > i for i in [c, d])
            # @info "Queue: Found better solution than $((a - 1, b, c)) or $((a, b - 1, d)) in $pq for key $k"
            _try_enqueue!(pq, (a - 1, b), c)
            _try_enqueue!(pq, (a, b - 1), d)
            delete!(pq, k)
            i, j = k
            return (i, j, qprod), ((i, j), qprod, pq)
        end
    end
    
    if c > d
        # @info "c > d: Found solution $((a - 1, b, c)) to be good.  Queueing $((a, b - 1, d)).  Queue currently $(isempty(pq) ? "empty" : pq)"
        _try_enqueue!(pq, (a, b - 1), d)
        return (a - 1, b, c), ((a - 1, b), c, pq)
    else
        # @info "c ≤ d: Found solution $((a, b - 1, d)) to be good.  Queueing $((a - 1, b, c)).  Queue currently $(isempty(pq) ? "empty" : pq)"
        _try_enqueue!(pq, (a - 1, b), c)
        return (a, b - 1, d), ((a, b - 1), d, pq)
    end
end


Base.eltype(iter::ProdIter) = NTuple{iter.m, Int}
# Base.length(iter::ProdIter) = sum(1:(iter.upper - iter.lower + 1))
# Base.length(iter::ProdIter) = (iter.n * (iter.n + iter.m − 1)) ÷ iter.m

Base.eltype(iter::ProdIter2) = NTuple{2, Int}
Base.length(iter::ProdIter2) = Base.SizeUnknown()

function reviter(lower::Int, upper::Int, m::Int)
    # sort!([a for a in Combinatorics.with_replacement_combinations(lower:upper, m)], by = prod, rev = true)
    A = collect(Combinatorics.multiset_permutations(lower:upper, m))
    for i in lower:upper
        push!(A, [i, i])
    end
    A = Vector{Int}[vcat(a, prod(a)) for a in A]
    return sort!(A, by = last, rev = true)
end

function approxeq(t1::NTuple{3, Int}, t2::NTuple{3, Int})
    eq = false
    prod1, prod2 = (last(t1), last(t2))
    if prod1 == prod2
        t1 = Tuple(sort!(vcat(t1[1:2]...)))
        t2 = Tuple(sort!(vcat(t2[1:2]...)))
        if t1 == t2
            eq = true
        end
    end
    return eq
end

R = 1:5
m = 2
for (i, j) in zip(ProdIter2(R.start, R.stop), reviter(R.start, R.stop, m))
    println(i, " — ", j, " — ", approxeq(i, Tuple(j)))
end
