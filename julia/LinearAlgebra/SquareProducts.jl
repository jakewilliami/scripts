function our_rand(i, j, T=Int32)
    function our_rand′(i, j)
        return abs.(rand(T, i*j))
    end
    function any_equal(A)
        return any(A[1] == A[i] for i in 2:length(A))
    end
    A = our_rand′(i, j)
    while any_equal(A)
        A = our_rand′(i, j)
    end
    sort!(A)
    reshape_rowwise(A) = reverse(rotr90(reshape(A, i, j)), dims=2)
    return BigInt.(reshape_rowwise(A))
end

function our_matmul(M1, M2)
    @assert size(M1) == size(M2)
    M = similar(M1)
    for i in CartesianIndices(M1)
        M[i] = M1[i] * M2[i]
    end
    return M
end

function old_transformations(M)
    M′ = reverse(M)
    return [
        M, rotr90(M), rot180(M), rotl90(M),
        M′, rotr90(M′), rot180(M′), rotl90(M′)
    ]
end

function transformations(M)
    M′, M′′, M′′′ = reverse(M, dims=1), reverse(M, dims=2), reverse(M)
    t(M) = (M, rotr90(M), rot180(M), rotl90(M))
    return unique([t(M)..., t(M′)..., t(M′′)..., t(M′′′)...])
end

function maximal_transformation(M)
    T = transformations(M)
    T′ = [sum(our_matmul(M, M′)) for M′ in T]
    i = argmax(T′)
    return T[i]
end

function our_is_identity(M)
    return maximal_transformation(M) == M
end

f(A, B) = all(a ∈ B for a in A)

# QED


function minimal_transformation(M)
    T = transformations(M)
    T′ = [sum(our_matmul(M, M′)) for M′ in T]
    i = argmin(T′)
    return T[i]
end

function our_is_identity′(M)
    return minimal_transformation(M) == reverse(M)
end
