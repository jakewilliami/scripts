using DataStructures: OrderedDict
using Combinatorics: permutations

### Helper structs

mutable struct Tile
    id::Int
    left::Vector{Char}
    right::Vector{Char}
    top::Vector{Char}
    bottom::Vector{Char}
    sz::Tuple{Int, Int}
end
Base.size(t::Tile) = t.sz
Base.size(t::Tile, d::Int) = size(t)[d]

mutable struct TilePermutation
    edges::OrderedDict{Int, Vector{Int}}
    tilemap::Dict{Int, NTuple{4, Int}}
end

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
flip(n::Int) = flip(n, 10)

### Parsing functions

function parse_input(input::String)
    title_re = r"^\w*\s(\d*):$"
    
    # split input into tiles
    tiles_raw = split(strip(input), "\n\n")
    ntiles = length(tiles_raw)
    tiles = Vector{Tile}(undef, ntiles)
    
    for i in 1:ntiles
        tile_raw = tiles_raw[i]
        # split each tile into rows of pixels
        tile_components = split(strip(tile_raw), '\n')
        # get tile ID
        title_match = match(title_re, popfirst!(tile_components))
        @assert (!isnothing(title_match) && length(title_match.captures) == 1) "Malformed title format in tile"
        id = parse(Int, only(title_match.captures))
        # get tile edges
        nrows = length(tile_components)
        left, right = Vector{Char}(undef, nrows), Vector{Char}(undef, nrows)
        for j in 1:nrows
            tile_row = tile_components[j]
            left[j] = tile_row[1]
            right[j] = tile_row[end]
        end
        top, bottom = collect(tile_components[1]), collect(tile_components[end])
        # put the constructed tile into the list of tiles
        tiles[i] = Tile(id, left, right, top, bottom, (nrows, length(top)))
    end
    
    return tiles
end

### Solve tile order

function solve_tile_order(tiles::Vector{Tile})
    tile_perm = TilePermutation(
        OrderedDict{Int, Vector{Int}}(),
        Dict{Int, NTuple{4, Int}}()
    )
    
    for tile in tiles
        l, r = 0, 0
        for (l_char, r_char) in zip(tile.left, tile.right)
            l <<= 1
            r <<= 1
            l |= Int(l_char == '#')
            r |= Int(r_char == '#')
        end
        
        t, b = 0, 0
        for (t_char, b_char) in zip(tile.top, tile.bottom)
            t <<= 1
            b <<= 1
            t |= Int(t_char == '#')
            b |= Int(b_char == '#')
        end
        
        l, r, t, b = (min(v, flip(v)) for v in (l, r, t, b)) # Tuple?
        
        tile_perm.tilemap[tile.id] = (t, l, b, r)
        for v in (t, l, b, r)
            tile_perm.edges[v] = push!(get(tile_perm.edges, v, Int[]), tile.id)
        end
    end
    
    return tile_perm
end

function get_corners(tile_perm::TilePermutation)
    corners = Int[]
    init_edge = nothing
    
    for (tile_id, tile) in tile_perm.tilemap
        match_cnt = 0
        unused = -1
        
        for edge in tile
            if length(tile_perm.edges[edge]) == 2
                match_cnt += 1
            elseif length(tile_perm.edges[edge]) == 1
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
    
    return corners
end

### Part One

function part1_old(tiles::Vector{<:AbstractString})
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
        
        l, r, t, b = (min(v, flip(v)) for v in (l, r, t, b)) # Tuple?
        
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
part1_old(filename::String) = part1_old(split(read(filename, String), "\n\n"))

function part1(input_path::String)
    input = read(input_path, String)
    tiles = parse_input(input)
    
    tile_perm = solve_tile_order(tiles)
    corners = get_corners(tile_perm)
    
    return prod(corners)
end

@assert part1_old("inputs/test20a1.txt") == 20899048083289
part1("inputs/test20a1.txt")


