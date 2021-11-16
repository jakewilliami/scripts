### Structs and consts

mutable struct Player
    id::Int
    deck::Vector{Int}
end

### Parsing

function parse_file(file_path::String)
    players = Player[]
    open(file_path) do file
        parsing_player = true

        id = 0
        deck = Int[]
        for line in eachline(file)
            if parsing_player
                id = parse(Int, last(split(line, ' '))[1:(end - 1)])
                parsing_player = false
            else
                if length(line) > 0
                    this_datum = parse(Int, line)
                    push!(deck, this_datum)
                else
                    push!(players, Player(id, deck))
                    deck = Int[]
                    parsing_player = true
                end
            end
        end
        push!(players, Player(id, deck))
    end
    
    @assert(length(players) == 2, "We expect only two players")
    
    return players
end

### Part 1

function draw_card!(player::Player)
    card = popfirst!(player.deck)
    return card
end

function draw_cards!(player1::Player, player2::Player)
    return draw_card!(player1), draw_card!(player2)
end

function play_combat_round!(player1::Player, player2::Player)
    card1, card2 = draw_cards!(player1, player2)
    if card1 > card2
        push!(player1.deck, card1, card2)
        return player1
    elseif card1 < card2
        push!(player2.deck, card2, card1)
        return player2
    else
        error("(hopefully) unreachable (draw in round)")
    end
end

function play_combat_game!(player1::Player, player2::Player)
    local winning_player::Player
    while !isempty(player1.deck) && !isempty(player2.deck)
        winning_player = play_combat_round!(player1, player2)
    end
    ncards = length(winning_player.deck)
    return sum(c * (ncards - i + 1) for (i, c) in enumerate(winning_player.deck))
end

function part1(input_file::String)
    player1, player2 = parse_file(input_file)
    return play_combat_game!(player1, player2)
end

@assert(part1("inputs/test22.txt") == 306)
@assert(part1("inputs/data22.txt") == 31957)

### Part 2

function play_recursive_combat_game!(player1::Player, player2::Player)
    local winning_player::Player
    previous_rounds = Set{UInt64}()
    
    while !isempty(player1.deck) && !isempty(player2.deck)
        game_state = hash((player1.deck, player2.deck))
        if game_state ∈ previous_rounds
            winning_player = player1
            break
        else
            push!(previous_rounds, game_state)
        end
        
        card1, card2 = draw_card!(player1), draw_card!(player2)
        
        if length(player1.deck) >= card1 && length(player2.deck) >= card2
            recursive_player1 = Player(player1.id, player1.deck[1:card1])
            recursive_player2 = Player(player2.id, player2.deck[1:card2])
            winning_player = play_recursive_combat_game!(recursive_player1, recursive_player2)
        else
            if card1 > card2
                winning_player = player1
            elseif card2 > card1
                winning_player = player2
            else
                error("(hopefully) unreachable (draw in round)")
            end
        end
        
        if winning_player.id == 1
            push!(player1.deck, card1, card2)
            winning_player = player1
        elseif winning_player.id == 2
            push!(player2.deck, card2, card1)
            winning_player = player2
        else
            error("unreachable")
        end
    end
    
    return winning_player
end

function part2(input_file::String)
    player1, player2 = parse_file(input_file)
    winning_player = play_recursive_combat_game!(player1, player2)
    ncards = length(winning_player.deck)
    return sum(c * (ncards - i + 1) for (i, c) in enumerate(winning_player.deck))
end

### Main

println(part1("inputs/data22.txt"))
println(part2("inputs/data22.txt"))

