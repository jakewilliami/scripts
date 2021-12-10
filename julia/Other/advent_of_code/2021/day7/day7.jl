using Statistics

function main()
    datafile = joinpath(@__DIR__, "data7.txt")
    data = Int[parse(Int, s) for s in split(strip(read(datafile, String)), ",")]
    
    m1 = round(Int, median(data))
    r1 = sum(abs(i - m1) for i in data)
    println("Part 1: ", r1)
    
    m2 = round(Int, mean(data))
    r2 = sum(sum(1:abs(i - m2)) for i in data)
    println("Part 2: ", r2)
end

main()
