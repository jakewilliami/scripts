part1(data::Vector{Int}) = 
    sum(data[i - 1] < data[i] for i in 2:length(data))

part2(data::Vector{Int}) = 
      sum((data[i - 1] + data[i - 2] + data[i - 3]) < (data[i] + data[i - 1] + data[i - 2]) for i in 4:length(data))

function main()
    data = Int[parse(Int, i) for i in eachline("data1.txt")]
    
    part1_solution = part1(data)
    println("Part 1: $(part1_solution)")
    
    part2_solution = part2(data)
    println("Part 2: $(part2_solution)")
end

main()
