# using Base.Iterators
# using IterTools

function execute(cmd::C) where {C <: Base.AbstractCmd}
    io = IOBuffer()
    run(pipeline(cmd, stdout = io))
    return String(take!(io))
end
cow = 
    vcat([split(a, ' ') for a in split(strip(execute(`cowsay -l`)), '\n')[2:end]]...)

cowsay() = 
    execute(pipeline(`fortune`, `cowsay -f $cow`))

println(cowsay())

# using BenchmarkTools
# A = split(strip(execute(`cowsay -l`)), '\n')[2:end]
# @btime rand(collect(Iterators.flatten(split.(A, ' ')))) #  10.012 μs (31 allocations: 7.02 KiB)
# @btime rand(collect(Iterators.flatten(split(a, ' ') for a in A))) # 9.671 μs (29 allocations: 6.83 KiB)
# @btime rand(vcat([split(l, ' ') for l in A]...)) # 8.989 μs (23 allocations: 4.83 KiB)
# @btime rand(vcat(map(a -> split(a, ' '), A)...)) # 9.168 μs (23 allocations: 4.83 KiB)
# @btime (I = Iterators.flatten(split(a, ' ') for a in A); a = nth(I, rand(1:sum(length, I.it))))
# @btime (I = Iterators.flatten(Iterators.map(a -> split(a, ' '), A)); a = nth(I, rand(1:sum(length, I.it))))
