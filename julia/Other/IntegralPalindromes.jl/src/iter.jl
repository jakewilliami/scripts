# TODO: rename upper => k, and m => r

struct ProdIter
    lower::Int
    upper::Int
    m::Int
end

# A helper function to enqueue something if and only if it doesn't already exist
_try_enqueue!(pq::PriorityQueue{K, V}, k::K, v::V) where {K, V} = k in keys(pq) ? pq : enqueue!(pq, k, v)

struct ProdIter2
    lower::Int
    upper::Int
end

# Iterators.Reverse{Squares}
# reviter.itr

Base.iterate(iter::ProdIter2) =
    ((iter.upper, iter.upper, iter.upper^2), ((iter.upper, iter.upper), iter.upper^2, PriorityQueue{NTuple{2, Int}, Int}(Base.Order.Reverse))) # or Base.Order.Forward, if we wanted to get the lowest element first

# Induction step
# TODO: generalise to m > 2
function Base.iterate(iter::ProdIter2, state::Tuple{NTuple{2, Int}, Int, PriorityQueue{NTuple{2, Int}, Int}}) # the state has ((xs...), prod, queue)
    t, product, pq = state # change product => _ ?
    a, b = t
    
    # skip those out of bounds
    # if ((a - 1) < iter.lower) || ((b - 1) < iter.lower)
    #     # return t, state
    #     return nothing
    # end
    
    # stop if either value is
    if ((a - 1) < iter.lower) && ((b - 1) < iter.lower) # all((i - 1) == iter.lower_bound for i in t)
    # if any((i - 1) < iter.lower for i in t)
        return nothing
    end
    
    c = (a - 1)b
    d = (b - 1)a

    if !isempty(pq)
        k, qprod = peek(pq)
        if qprod > c || qprod > d # any(qprod > i for i in [c, d])
            @info "Queue: Found better solution than $((a - 1, b, c)) or $((a, b - 1, d)) in $pq for key $k"
            if (a - 1) ≥ iter.lower
                _try_enqueue!(pq, (a - 1, b), c)
            end
            if (b - 1) ≥ iter.lower
                _try_enqueue!(pq, (a, b - 1), d)
            end
            delete!(pq, k)
            i, j = k
            return (i, j, qprod), ((i, j), qprod, pq)
        end
    end
    
    if c > d
        @info "c > d: Found solution $((a - 1, b, c)) to be good.  Queueing $((a, b - 1, d)).  Queue currently $(isempty(pq) ? "empty" : pq)"
        _try_enqueue!(pq, (a, b - 1), d)
        return (a - 1, b, c), ((a - 1, b), c, pq)
    else
        @info "c ≤ d: Found solution $((a, b - 1, d)) to be good.  Queueing $((a - 1, b, c)).  Queue currently $(isempty(pq) ? "empty" : pq)"
        _try_enqueue!(pq, (a - 1, b), c)
        return (a, b - 1, d), ((a, b - 1), d, pq)
    end
end


function _prod_iter_len(n::Int, m::Int)
    if m == 1
        return n
    end
    # f = Int[sum(c == x for c in 1:n) for x in unique(1:n)]
    f = ones(Int, n) # if it's always a range, then this is fine
    local g::Vector{Integer}
    if m > 20
        g = [factorial(big(i)) for i in 0:m]
    else
        g = [factorial(i) for i in 0:m]
    end
    p = vcat(g[m + 1], zeros(Float64, m))
    for (i, a) in enumerate(f)
        if i == 1
            for j in 1:min(a, m)
                p[j + 1] = g[m + 1] / g[j + 1]
            end
        else
            for j in m:-1:1
                q = 0
                for k in (j + 1):-1:max(1, j - a + 1)
                    q += p[k] / g[j - k + 2]
                end
                p[j + 1] = q
            end
        end
    end
    return round(Int, p[m+1]) + n
end


Base.eltype(iter::ProdIter) = NTuple{iter.m, Int}
Base.length(iter::ProdIter) = _prod_iter_len(iter.upper - iter.lower + 1, iter.m)

Base.eltype(iter::ProdIter2) = NTuple{2, Int}
Base.length(iter::ProdIter2) = _prod_iter_len(iter.upper - iter.lower + 1, 2)

# function approxeq(t1::NTuple{3, Int}, t2::NTuple{3, Int})
#     eq = false
#     prod1, prod2 = (last(t1), last(t2))
#     if prod1 == prod2
#         t1 = Tuple(sort!(vcat(t1[1:2]...)))
#         t2 = Tuple(sort!(vcat(t2[1:2]...)))
#         if t1 == t2
#             eq = true
#         end
#     end
#     return eq
# end
#
# function Base.count(::Type{ProdIter2}, lower::Int, upper::Int)
#     i = 0
#     for _ in ProdIter2(lower, upper)
#         i += 1
#     end
#     return i
# end
# Base.count(::Type{ProdIter2}, R::UnitRange{Int}) = count(ProdIter2, R.start, R.stop)

# R = 1:5
# m = 2
# for (i, j) in zip(ProdIter2(R.start, R.stop), reviter(R.start, R.stop, m))
#     println(i, " — ", j, " — ", approxeq(i, Tuple(j)))
# end

# using BenchmarkTools
# using LinearAlgebra
# # t = fill((3, 4, 5), 3)
# t = [ntuple(i -> Int(rand(Int8)), 10) for _ in 1:10]
# # t = [ntuple(i -> Int(rand(Int8)), abs(rand(Int8))) for _ in 1:rand(Int8)]
# function f(t::Vector{NTuple{N, Int}}) where N
#     return (ntuple(j -> i == j ? t[i][j] - 1 : t[i][j], N) for i in 1:N)
# end
# function g(t::Vector{NTuple{N, Int}}) where N
#     standard_bases = LinearAlgebra.I(N)
#     return (t[i] .- standard_bases[:, i] for i in 1:N) # column-wise is faster
# end
# function h(t::Vector{NTuple{N, Int}}) where N
#     standard_bases = LinearAlgebra.I(N)
#     return (ntuple(j -> t[i][j] - standard_bases[j, i], N)  for i in 1:N)
# end


#
# if m < 100, f, : g
# function f(t::Vector{NTuple{N, Int}}) where N
#     return (ntuple(j -> i == j ? t[i][j] - 1 : t[i][j], N) for i in 1:N)
# end
# function g(t::Vector{NTuple{N, Int}}) where N
#     standard_bases = LinearAlgebra.I(N)
#     return (t[i] .- standard_bases[:, i] for i in 1:N) # column-wise is faster
# end
