using Primes, Plots, Luxor, Colors, Cairo

LARGEST_DEC_2020 = big(2)^82_589_933 - 1
# p^2 == n*24 + 1

function find_primes_alt(max_prime_counter::Integer)
    prime_counter = 0
    possible_prime = 2
    res = []
    while prime_counter < max_prime_counter
        if isprime(possible_prime)
            p′ = mod(possible_prime, 2π)
            push!()
            prime_counter += 1
        end
        possible_prime += 1
    end
    return 
end

#=
function find_primes(max_prime::Integer)
    res = []
    for p in primes(max_prime)
        p′ = mod(p, 2π)
        push!(res, p′)
    end
    
    return res
end
=#

function find_primes(max_prime_counter::Integer)
    P = Dict()
    prime_view = nextprimes(1, max_prime_counter)
    for (i, p) in enumerate(prime_view)
        prev_p = i == 1 ? 0 : prime_view[i - 1]
        Δp = p - prev_p
        # p′ = mod(p, 2π)
        # P[p] = p′
        # P[i] = p′
        P[i] = Δp
    end
    
    return P
end

function plot_primes(max_prime_counter::Integer)
    P = find_primes(max_prime_counter)
    out_file = joinpath(@__DIR__, "primes.pdf")
    plt = scatter(
        collect(keys(P)), collect(values(P)),
        xlabel = "Prime count",
        ylabel = "Distance since previous prime"
        # ylabel = "Prime modulo 2π"
    )
    savefig(plt, outpath)
    
    return plt
end

function draw_turtle(max_prime_counter::Integer)
    out_file = joinpath(@__DIR__, "prime_turtle.pdf")
    Drawing(1000, 1000, out_file)
	origin()
    
    🐢 = Turtle()
    Pencolor(🐢, "black")
	Penwidth(🐢, 0.1)
    n = 5
    golden_angle = 137.5
	angle = golden_angle
    
    i = 1
    P = find_primes(max_prime_counter)
    prime_counter = 0
    prev_prime = 2
    while true
        i+= 1
        if isprime(i)
            Turn(🐢, angle)
            prime_counter += 1
            Forward(🐢, i - prev_prime)
            prev_prime = i
        end
        if prime_counter ≥ max_prime_counter
            break
        end
    end
    #=
    while true
        Δp = get(P, i, :notaprime)
        if Δp != :notaprime
            Turn(🐢, angle)
            prime_counter += 1
        end
        Forward(🐢, n)
        i += 1
        if prime_counter >= max_prime_counter
            break
        end
    end
    =#
    
    Luxor.finish()
    return 🐢
end

function naïve_search(min_prime_counter::Integer, max_prime_counter::Integer)
    ndigits_vec = Integer[]
    ndigits_vec_b2 = Integer[]
    pos_vec = Integer[]
    primes_vec = Integer[]
    for (i, p) in enumerate(primes(min_prime_counter, max_prime_counter))
        b = string(p, base = 2)
        push!(ndigits_vec, ndigits(p))
        push!(ndigits_vec_b2, length(b))
        push!(pos_vec, i)
        push!(primes_vec, p)
    end
    
    outpath = joinpath(@__DIR__, "primes_by_ndigits_base2.pdf")
    plt = scatter(
        pos_vec, ndigits_vec,
        label = "ndigits",
        xlabel = "Prime counter",
        ylabel = "Number of digits in prime (base 2)"
    )
    scatter!(pos_vec, ndigits_vec_b2, label = "ndigits in base2")
    savefig(plt, outpath)
    
    return plt
end

# plot_primes(100_000)
# draw_turtle(100_000)
naïve_search(1, 10_000_000)
