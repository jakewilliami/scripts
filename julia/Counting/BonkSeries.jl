# Fibonnaci series
function f(n::Int)
    n ≤ 2 && return 1
    return f(n - 1) + f(n - 2)
end

# Bonk series:
# Each new item is bitand of previous two
function f′(n::Int)
    n ≤ 2 && return n
    return (n - 1) | (n - 2)
end
f′′(n::Int) = mod(f′(n), 10)

p(n::Int, fn::String = "f") = "$(fn)($(n)) = $(eval(Symbol(fn))(n))"

function print_seq(n::Int, fn::String = "f")
    for i in 1:n
        print(p(i, fn))
        i < n ? print(", ") : println()
    end
end

n = 1000
# print_seq(n, "f")
# print_seq(n, "f′")

# for i in 1:n
#     println(p(i, "f′"))
# end

# Some of these are surprisingly large.
# This is because(?) the result is one minus a power of 2
# And the input is one *plus* the previous power of 2
# That is:
#   f′(2ᵏ⁻¹ + 1) = 2ᵏ - 1
#                = (2ᵏ⁻¹) | (2ᵏ⁻¹ - 1)
for i in 1:n
    m = f′(i)
    k = i ÷ 2
    if (m - i) ≥ k
        println(p(i, "f′"), "; k = $(round(Int, log2(m + 1)))")
    end
end
