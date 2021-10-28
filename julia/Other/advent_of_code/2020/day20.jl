using DataStructures: OrderedDict
using Combinatorics: permutations

### Helper structs

struct Tile
    id::Int
    pixels::Matrix{Char}
end
Base.size(t::Tile) = size(t.pixels)
Base.size(t::Tile, d::Int) = size(t.pixels, d)

struct TilePermutation
    tiles::Matrix{Tile}
    function TilePermutation(tiles::Matrix{Tile})
        sz1 = size(first(tiles))
        @assert all(size(tiles[i]) == sz1 for i in eachindex(tiles)) "All tiles must have the same size"
        return new(tiles)
    end
end
function TilePermutation(tiles::Vector{Tile})
    nrows = isqrt(size(first(tiles), 1))
    @assert mod1(length(tiles), nrows) == nrows "Cannot produce a square formation from $(length(tiles)) tiles"
    return TilePermutation(reshape(tiles, nrows, nrows))
end
TilePermutation(tiles_raw::Array{Matrix{Char}, N}) where {N} =
    TilePermutation(Tile[Tile(0, pixels) for pixels in tiles_raw])

Base.size(t::TilePermutation) = size(t.tiles)
Base.size(t::TilePermutation, d::Int) = size(t.tiles, d)
Base.length(t::TilePermutation) = length(t.tiles)
Base.eltype(t::TilePermutation) = Tile

function Base.show(io::IO, tiles::TilePermutation)
    M = tiles.tiles
    nrows = size(M, 1)
    ncols = size(first(M).pixels, 2)
    for (i, r1) in enumerate(eachrow(M))
        for j in 1:ncols
            for k in 1:length(r1)
                print(io, join(r1[k].pixels[j, :]), " ")
            end
            (i == nrows && j == ncols) || println(io)
        end
        i == nrows || println(io)
    end
end

### Parsing functions

function parse_input(input::String)
    title_re = r"^\w*\s(\d*):$"
    tiles_raw = split(input, "\n\n")
    tiles = Tile[]
    for tile_raw in tiles_raw
        tile_components = split(tile_raw, '\n')
        title_match = match(title_re, popfirst!(tile_components))
        @assert (!isnothing(title_match) && length(title_match.captures) == 1) "Malformed title format in tile"
        id = parse(Int, only(title_match.captures))
        pixels = reduce(vcat, permutedims(collect(s)) for s in tile_components if !isempty(s))
        push!(tiles, Tile(id, pixels))
    end
    return tiles
end

### Check permutation is valid

# Very efficient method for checking if a permutation of tiles is valid
# I.e., if they line up correctly
function Base.isvalid(tiles::TilePermutation, nrows::Int)
    tile_matrix = tiles.tiles
    tile_nrows, tile_ncols = size(first(tile_matrix))
    
    # iterate over the rows of the tile matrix and check that
    # each tile matches the end of the tile above it
    # with the exception of the first row, which does not need
    # to match anything
    for (i, indices) in enumerate(eachrow(CartesianIndices(tile_matrix)))
        i == 1 && continue
        for j in indices
            row_tile = tile_matrix[j]
            
            # check the previous row of tiles
            top_of_tile = view(row_tile.pixels, 1, :)
            bottom_of_tile_above = view(tile_matrix[j - CartesianIndex(1, 0)].pixels, tile_nrows, :)
            top_of_tile != bottom_of_tile_above && return false
        end
    end
    
    # do the same as above, over the columns of the tile matrix
    # leaving out the first column, as we are checking the tiles in
    # the column to the left
    for (i, indices) in enumerate(eachcol(CartesianIndices(tile_matrix)))
        i == 1 && continue
        for j in indices
            col_tile = tile_matrix[j]
            
            # check the previous column of tiles
            leftmost_column_of_tile = view(col_tile.pixels, :, 1)
            rightmost_column_of_tile_to_the_left = view(tile_matrix[j - CartesianIndex(0, 1)].pixels, :, tile_nrows)
            leftmost_column_of_tile != rightmost_column_of_tile_to_the_left && return false
        end
    end
    
    # We have not failed yet, so this permutation works
    return true
end
Base.isvalid(tiles::TilePermutation) = isvalid(tiles, size(tiles, 1))

### Solve for the desired permutation

function solve_tile_order(tiles::Vector{Tile}, ntiles::Int, nrows::Int)
    tile_perms = permutations(1:ntiles)
    rot_perms = Iterators.product((0:3 for _ in 1:9)...)
    
    for tile_order in tile_perms
        for rot_perm in rot_perms
            new_tile_permutation = Tile[r == 0 ? tiles[i] : Tile(tiles[i].id, rotr90(tiles[i].pixels, r))
                for (i, r) in zip(tile_order, rot_perm)]
            tile_perm = TilePermutation(new_tile_permutation)
            if isvalid(tile_perm, nrows)
                return tile_perm
            end
        end
    end
    
    return nothing
end

### Part One

function part1(input_path::String)
    input = read(input_path, String)
    tiles = parse_input(input)
    
    # Calculate the length of each side of the tile square
    ntiles = length(tiles)
    nrows = isqrt(ntiles)
    @assert mod1(ntiles, nrows) == nrows "Cannot produce a square formation from $ntiles tiles"
    
    # Find the correct permutation and return the product result
    correct_tile_permutation = solve_tile_order(tiles, ntiles, nrows)
    if !isnothing(correct_tile_permutation)
        # correct_tile_permutation = reshape(correct_tile_permutation, nrows, nrows)
        # corner_indices = (1, nrows, nrows^2 - nrows + 1, nrows^2)
        println([tile.id for tile in correct_tile_permutation])
        corner_indices = (CartesianIndex(1, 1), CartesianIndex(1, nrows), CartesianIndex(nrows, 1), CartesianIndex(nrows, nrows))
        return prod(correct_tile_permutation[i].id for i in corner_indices)
    else
        return 0
    end
end

# part1("inputs/test20a1.txt")

# M = TilePermutation(reshape(Matrix{Char}[reduce(vcat, permutedims(collect(s)) for s in split(t)) for t in split(read("inputs/test20a2.txt", String), "\n\n")], 3, 3))
# isvalid(M)

##################################################################################################

DEFAULT_M = 10

function flip(n::Int, m::Int)
    res = 0
    for _ in 1:m
        res <<= 1
        if (n & 1) == 1
            res |= 1
        end
        n >>= 1
    end
    return res
end
flip(n::Int) = flip(n, DEFAULT_M)

edge_id(n::Int) = min(n, flip(n))



function part1(tiles::Vector{<:AbstractString})
    orig_tiles = Dict()
    # edges = DefaultDict([])
    edges = OrderedDict()
    tilemap = Dict()
    
    for tile in tiles
        tile_components = split(strip(tile), '\n')
        header = tile_components[1]
        img = tile_components[2:end]
        
        tile_id = parse(Int, split(header, ' ')[2][1:(end - 1)])
        orig_tiles[tile_id] = img
        
        l, r = 0, 0
        for line in img
            l <<= 1
            r <<= 1
            l |= (line[1] == '#' ? 1 : 0) # |= Int(line[1] == '#')
            r |= (line[end] == '#' ? 1 : 0)
        end
        
        t, b = 0, 0
        for i in 1:length(img[1])
            t <<= 1
            b <<= 1
            t |= (img[1][i] == '#' ? 1 : 0)
            b |= (img[end][i] == '#' ? 1 : 0)
        end
        
        l, r, t, b = (edge_id(v) for v in (l, r, t, b)) # Tuple?
        
        # @info tile_id, string(l, base = 2), string(r, base = 2), string(t, base = 2), string(b, base = 2)
        
        tilemap[tile_id] = (t, l, b, r)
        # push!(edges[l], tile_id)
	    # push!(edges[r], tile_id)
	    # push!(edges[t], tile_id)
	    # push!(edges[b], tile_id)
        edges[l] = push!(get(edges, l, []), tile_id)
        edges[r] = push!(get(edges, r, []), tile_id)
        edges[t] = push!(get(edges, t, []), tile_id)
        edges[b] = push!(get(edges, b, []), tile_id)
    end
    
    corners = []
    init_edge = nothing
    
    for (tile_id, tile) in tilemap
        match_cnt = 0
        unused = -1
        
        for edge in tile
            if length(edges[edge]) == 2
                match_cnt += 1
            elseif length(edges[edge]) == 1
                unused = edge
            end
        end
        
        @assert match_cnt >= 2
        
        if match_cnt == 2
            push!(corners, tile_id)
            if isnothing(init_edge)
                init_edge = unused
            end
        end
    end
    
    
    return prod(corners)
end
part1(filename::String) = part1(split(read(filename, String), "\n\n"))

@assert part1("inputs/test20a1.txt") == 20899048083289
