struct RamseyParty
    k::Int  # Number of people you want to know each other or don't
    n::Int  # Number of people at the party
end

function upper_bound_n(k::Int)
    # https://www.rnz.co.nz/national/programmes/nights/audio/2018891414/maths-finding-order-amongst-the-chaos
    # return 4^k
    return round(Int, 3.9922^k)
end

n_edges_complete_graph(n::Int) = binomial(n, 2)

function determine_valid(k::Int, m::Int, m′::Int)

end

# Calculate n given some w
function RamseyParty(k::Int)
    # Handle base cases
    k ∈ 0:2 && return k

    # The number of people you want to know each other (or not)
    # must be at least the number of people at the party.  So we
    # can start looking at w
    n = k
    while n <= upper_bound_n(k)
        # m is the minimum number of people you must know or not
        # know at the party, as you must have a majority
        m = cld(n - 1, 2)

        # You know at least m people
        # First, as we must be sure within our subset m′,
        # we need to ignore the possibility that k is satisfied
        # with the minority group, as this is not a guarantee
        m < k && @goto next_iter

        # i people from m know each other
        for i in 1:cld(m, 2)
            # Base case: i = 1: one person knows themselves
            # (and you).
            # i = 2: you know two people, and they know each
            # other.
            # And so on and so fifth.

            # TODO: check that i people know each other: does
            # that satisfy k?
            # Then, check that not i people know each other:
            # does that satisfy the inverse?
            #
            # For example, you have m = 3.  If two of those
            # people know each other (i = 2), then we have
            # out answer.  If i = 1 (i.e., none of those people
            # know each other, then we have an inverse.

            # TODO: how can we determine if i satisfies k?
            # First, check that i people know each other:
            if (i + 1) == k
                println("k = $(k); n = $(n); m = $(m); i = $(i)")
                return RamseyParty(k, n)
            end

            # Then, check that the inverse do not:
            if (m - i) == k
                println("k = $(k); n = $(n); m = $(m); i = $(i)")
                return RamseyParty(k, n)
            end
        end

        @label next_iter
        n += 1
    end

    error("Cannot find a value for n with k=$k")
end

RamseyParty(1)  # 1
RamseyParty(2)  # 2
RamseyParty(3)  # 6
RamseyParty(5)  # 43–48
