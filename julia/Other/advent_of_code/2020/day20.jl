### Enums and consts

const TILE_WIDTH = 10
const TILE_HEIGHT = 10

@enum Side begin
    TOP = 1
    RIGHT = 2
    BOTTOM = 3
    LEFT = 4
end

@enum Corner begin
    TOP_LEFT     = 1
    TOP_RIGHT    = 2
    BOTTOM_RIGHT = 3
    BOTTOM_LEFT  = 4
end

CORNER_INDICES = Dict{Corner, Vector{Bool}}(
    TOP_LEFT     => Bool[0, 1, 1, 0],
    TOP_RIGHT    => Bool[0, 0, 1, 1],
    BOTTOM_RIGHT => Bool[1, 0, 0, 1],
    BOTTOM_LEFT  => Bool[1, 1, 0, 0]
)

CORNER_VALUES = Dict{Vector{Bool}, Corner}(v => k for (k, v) in CORNER_INDICES)

### Struct

struct Tile
    id::Int
    data::Matrix{Char}
    rows::Vector{String}
    sides::Vector{String}
    top::Vector{Char}
    right::Vector{Char}
    bottom::Vector{Char}
    left::Vector{Char}
end
function Tile(id::Int, data::Matrix{Char}, rows::Vector{String})
    top, bottom = data[1, :], data[end, :]
    left, right = data[:, 1], data[:, end]
    sides = String[join(top), join(right), join(bottom), join(left)]
    return Tile(id, data, rows, sides, top, right, bottom, left)
end
Tile(id::Int, data::Matrix{Char}) =
    Tile(id, data, String[join(row) for row in eachrow(data)])

Base.rotr90(tile::Tile) = Tile(tile.id, rotr90(tile.data))
flip(tile::Tile) = Tile(tile.id, reverse(tile.data, dims = 1))

### Parse input

matrixise(rows::Vector{T}) where {T} =
    reduce(vcat, permutedims(collect(r)) for r in rows)::Matrix{eltype(T)}

function parse_file(file_path::String)
    tiles = Tile[]
    open(file_path) do file
        parsing_tile = true

        id = 0
        rows = String[]
        for line in eachline(file)
            if parsing_tile
                id = parse(Int, last(split(line, ' '))[1:(end - 1)])
                parsing_tile = false
            else
                if length(line) > 0
                    push!(rows, line)
                else
                    push!(tiles, Tile(id, matrixise(rows), rows))
                    rows = String[]
                    parsing_tile = true
                end
            end
        end
        push!(tiles, Tile(id, matrixise(rows), rows))
    end
    
    return tiles
end

function find_bottom_right_tile(left::Tile, top::Tile, tiles::Vector{Tile})
    for tile in tiles
        if top.id != tile.id && left.id != tile.id
            candidate = tile

            for i in 1:4
                if top.bottom == candidate.top && left.right == candidate.left
                    return candidate
                end
                candidate = rotr90(candidate)
            end

            candidate = flip(tile)

            for i in 1:4
                if top.bottom == candidate.top && left.right == candidate.left
                    return candidate
                end
                candidate = rotr90(candidate)
            end
        end
    end

    @warn("Could not find tile for `find_bottom_right_tile`")
    return nothing
end

function find_side_tile(tile_a::Tile, tiles::Vector{Tile}, i::Side, j::Side)
    for tile in tiles
        tile_a.id == tile.id && continue
        tile_b = tile
        for _ in 1:4
            if tile_a.sides[Int(i)] == (tile_b).sides[Int(j)]
                return tile_b
            end
            tile_b = rotr90(tile_b)
        end
        tile_b = flip(tile_b)
        for _ in 1:4
            if tile_a.sides[Int(i)] == (tile_b).sides[Int(j)]
                return tile_b
            end
            tile_b = rotr90(tile_b)
        end
    end

    @warn("Could not find tile for `find_side_tile` for side $i")
    return nothing
end

for sidename in (:right, :bottom, :left, :top)
    sidename_upper = Symbol(uppercase(string(sidename)))
    fname = Symbol("find_$(sidename)_tile")
    sidename_sym = Symbol("$sidename")
    @eval begin
        $fname(tile_a::Tile, tiles::Vector{Tile}) =
            find_side_tile(tile_a, tiles, $sidename_upper, instances(Side)[mod1(Int($sidename_upper) - 2, Side.size)])
    end
end

function side_matches(candidate::Tile, tiles::Vector{Tile})
    # The idea is to keep track of how many sides of tiles the candidate is compatible with.
    # If the number is exactly two, then it is in on a corner.  We do not have to do any
    # reconstruction of the image at this stage
    itr = Iterators.product((1:4 for i in 1:2)...) # equivalent to `for i in 1:4, j in 1:2`
    cs = zeros(Bool, 4)
    for tile in tiles
        candidate.id == tile.id && continue
        for (i, j) in itr
            cs[i] = cs[i] || (candidate.sides[i] ∈ (tile.sides[j], reverse(tile.sides[j])))
        end
    end
    
    return cs
end

iscorner(candidate::Tile, tiles::Vector{Tile}) =
    count(side_matches(candidate, tiles)) == 2

function part_1(tiles::Vector{Tile})
    result = 1
    for tile in tiles
        if iscorner(tile, tiles)
            result *= tile.id
        end
    end
    return result
end

# count_hash(tile::Tile) = count(==('#'), tile.data)
count_hash(lines::Vector{<:AbstractString}) =
    sum(count(==('#'), line) for line in lines)

const SEAMONSTER = ["                  # ",
                     "#    ##    ##    ###",
                     " #  #  #  #  #  #   "]

@assert(all(length(line) == length(first(SEAMONSTER)) for line in SEAMONSTER[2:end]))
SEAMONSTER_WIDTH = length(first(SEAMONSTER))
SEAMONSTER_HEIGHT = length(SEAMONSTER)


function contains_monster(drow::Int, dcol::Int, picture::Vector{String})
    for r0 in 1:SEAMONSTER_HEIGHT
        for c0 in 1:SEAMONSTER_WIDTH
            if SEAMONSTER[r0][c0] == '#'
                if picture[r0 + drow - 1][c0 + dcol - 1] != '#'
                    return false
                end
            end
        end
    end
    return true
end

function count_monsters(picture::Vector{<:AbstractString}, tiles_per_row::Int)
    result = 0
    for drow in 1:(((TILE_HEIGHT - 2) * tiles_per_row) - SEAMONSTER_HEIGHT)
        for dcol in 1:(((TILE_WIDTH - 2) * tiles_per_row) - SEAMONSTER_WIDTH)
            if contains_monster(drow, dcol, picture)
                result += 1
            end
        end
    end
    return result
end

function part_2(tiles::Vector{Tile})
    puzzle = Vector{Vector{Tile}}()
    
    push!(puzzle, Vector{Tile}())
    for tile in tiles
        if side_matches(tile, tiles) == CORNER_INDICES[TOP_LEFT]
            push!(puzzle[1], tile)
            break
        end
    end
    
    row_len = isqrt(length(tiles))
    
    for i in 2:row_len
        right_tile = find_right_tile(puzzle[1][i - 1], tiles)
        push!(puzzle[1], right_tile)
    end
    
    for i in 2:row_len
        push!(puzzle, Vector{Tile}())
        bottom_tile = find_bottom_tile(puzzle[i - 1][1], tiles)
        push!(puzzle[i], bottom_tile)
            
        for j in 2:row_len
            bottom_right = find_bottom_right_tile(puzzle[i][j - 1], puzzle[i - 1][j], tiles)
            push!(puzzle[i], bottom_right)
        end
    end
    
    picture = Vector{String}()
    for row in puzzle
        for i in 2:(TILE_WIDTH - 1)
            picture_row = Vector{String}()
            for tile in row
                push!(picture_row, tile.rows[i][2:(end - 1)])
            end
            push!(picture, join(picture_row))
        end
    end
        
    picture = reverse(picture)
    @info count_hash(picture), count_monsters(picture, row_len), count_hash(SEAMONSTER)
    return count_hash(picture) - count_monsters(picture, row_len) * count_hash(SEAMONSTER)
end

function solve_file(file_path::String)
    # Parse file
    test_tiles = parse_file("inputs/test20a1.txt")
    tiles = parse_file(file_path)
    # Part 1
    p1 = part_1(tiles)
    println("Part 1: $p1")
    println("\tTest result:     $(part_1(test_tiles) == 20899048083289)")
    println("\tExpected result: $(p1 == 60145080587029)")
    # Part 2
    @warn("Part 2 is not counting sea monsters correctly :-(")
    p2 = part_2(tiles)
    println("Part 2: $p2")
    println("\tTest result:     $(part_2(test_tiles) == 273)")
    println("\tExpected result: $(p2 == 1901)")
end

solve_file("inputs/data20.txt")
