using BenchmarkTools

TABLE = [
    0,
    1,
    1,
    0,
    1,
    0,
    0,
    0
]

TABLE_AS_UINT8 = parse(UInt8, reverse(join(TABLE)), base = 2)

i = rand(1:8)

@btime TABLE[i]
@btime (TABLE_AS_UINT8 >> i) & 1
