using StatsBase, Primes, BenchmarkTools

FIRST_26_PRIMES = Primes.nextprimes(1, 26)

##############################################################

function my_manual_mutating_method(str1::AbstractString, str2::AbstractString)
    length(str1) != length(str2) && return false
    
    str2_arr = collect(str2)
    
    for c1 in str1
        i = findfirst(==(c1), str2_arr)
        !isnothing(i) && deleteat!(str2_arr, i)
    end

    return isempty(str2_arr)
end

function my_countmap(str1::AbstractString, str2::AbstractString)
    length(str1) != length(str2) && return false
    
    str2_countmap = StatsBase.countmap(str2)
    str2_chars = keys(str2_countmap)
    for c1 in str1
        if c1 ∈ str2_chars
            str2_countmap[c1] = str2_countmap[c1] - 1
        end
    end

    is_anagram = true
    for i in values(str2_countmap)
        if i != 0
            is_anagram = false
            break
        end
    end

    return is_anagram
end

function online_countmap(str1::AbstractString, str2::AbstractString)
    length(str1) != length(str2) && return false
    
    str1_countmap = StatsBase.countmap(str1)
    str2_countmap = StatsBase.countmap(str2)
    
    is_anagram = true
    for (k1, v1) in str1_countmap
        i = get(str2_countmap, k1, nothing)
        if isnothing(i) || i != v1
            is_anagram = false
            break
        end
    end
    
    return is_anagram
end

function online_sort(str1::AbstractString, str2::AbstractString)
    length(str1) != length(str2) && return false

    return sort(collect(str1)) == sort(collect(str2))
end

# fundamental theorem of arithmetic
function online_primes(str1::AbstractString, str2::AbstractString)
    length(str1) != length(str2) && return false
    
    prime_map = Dict(a => FIRST_26_PRIMES[i] for (i, a) in enumerate('a':'z'))
    prod1, prod2 = (1, 1)
    for (c1, c2) in zip(str1, str2)
        prod1 *= prime_map[c1]
        prod2 *= prime_map[c2]
    end
    
    return prod1 == prod2
end

##############################################################

struct CaseInsensitive end
case_insensitive = CaseInsensitive()

for f in (:my_manual_mutating_method, :my_countmap, :online_countmap, :online_sort, :online_primes)
    @eval $f(str1::AbstractString, str2::AbstractString, case_insensitive::CaseInsensitive) = $f(lowercase(str1), lowercase(str2))
end

str1, str2 = ("anna", "nana")

for f in (:my_manual_mutating_method, :my_countmap, :online_countmap, :online_sort, :online_primes)
    println("testing method $f")
    @eval @btime $f(str1, str2)
end
