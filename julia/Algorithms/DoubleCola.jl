# Sheldon, Leonard, Penny, Rajesh, and Howard are in the queue for a
# "Double Cola" drink at the vending machine.  There are no other
# people in the queue.  The first one in the queue (Sheldon) buys a
# can, drinks it, and doubles!  The resulting two Sheldons go to the
# end of the queue.  Then, the next in the queue (Leonard) buys a
# can, drinks it, and gets to the end of the queue as two Leonards,
# and so on.
#
# Who will drink the nth cola?

mutable struct PersonGroup
    n::Int
    name::String
end

function _f(n::Int)
    V = map(n -> PersonGroup(1, n), ["Sheldon", "Leonard", "Penny", "Rajesh", "Howard"])
    local p::PersonGroup
    # i = 1
    m = 0
    while true
        # j = mod1(i, length(V))
        p = popfirst!(V)
        p.n *= 2
        push!(V, p)
        m += p.n - 1
        if m > n
            break
        end
    end
    println(V)
    return V
end

f(n::Int) = last(_f(n))  # Nth cola consumer
g(n::Int) = first(_f(n))  # Who is next?

function check_result(n::Int, expected::String)
    println("Checking that f($n) = $expected")
    res = g(n).name
    @assert res == expected "Uh oh!  $res ≠ $expected"
end

check_result(5, "Sheldon")
check_result(52, "Penny")
check_result(10010, "Howard")
