using Combinatorics

for a in permutations(1:8, 3)
    b1, b2, b3 = a
    filename = joinpath("/Volumes", "old-data", "hackathon", 
"combinations", "$(b1),$(b2),$(b3).tif")
    isfile(filename) || run(`gdal_translate -b $b1 -b $b2 -b $b3 ../test.TIF $filename`)
end
