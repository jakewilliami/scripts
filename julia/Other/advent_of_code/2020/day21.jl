### Structs

struct Food
    ingredients::Vector{String}
    allergens::Vector{String}
end

### Parsing

function parse_input(filename::String)
    food_re = r"^(.*)\s\(contains\s(.*)\)$"
    local foods::Vector{Food}
    open(filename, "r") do io
        foods = Vector{Food}(undef, countlines(io))
        for (i, line) in enumerate(eachline(filename))
            food_match = match(food_re, line)
            @assert (!isnothing(food_match) && length(food_match.captures) == 2) "Malformed food format in line: \"$line\""
            ingredients_str, allergens_str = food_match.captures
            ingredients = split(ingredients_str, isspace)
            allergens = split(allergens_str, ", ")
            foods[i] = Food(ingredients, allergens)
        end        
    end
    return foods
end

### Part 1

function solve_allergens(foods::Vector{Food})
    solved = Dict{String, String}() # allergen, ingredient
    unsolved = Dict{String, Vector{String}}() # allergen, possible_ingredients
    local current_allergen::String
    for (i, food) in enumerate(foods)
        if length(food.allergens) == 1
            current_allergen = only(food.allergens)
            allergen_indices = Int[]
            if !haskey(solved, current_allergen)
                for (j, food) in enumerate(foods)
                    if current_allergen ∈ food.allergens && i != j
                        push!(allergen_indices, j)
                    end
                end
                possible_ingredients = food.ingredients
                for k in allergen_indices
                    combined_ingredients = String[]
                    k_ingredients = foods[k].ingredients
                    for k_ingredient in k_ingredients
                        if k_ingredient ∈ possible_ingredients
                            push!(combined_ingredients, k_ingredient)
                        end
                    end
                    possible_ingredients = copy(combined_ingredients)
                end
                if length(possible_ingredients) == 1
                    solved[current_allergen] = only(possible_ingredients)
                else
                    unsolved[current_allergen] = possible_ingredients
                end
            end
        end
    end
    
    while !isempty(unsolved)
        still_unsolved = Dict{String, Vector{String}}() # allergen, possible_ingredients
        for (unsolved_allergen, unsolved_ingredients) in unsolved
            possible_ingredients = String[]
            for unsolved_ingredient in unsolved_ingredients
                if unsolved_ingredient ∉ values(solved)
                    push!(possible_ingredients, unsolved_ingredient)
                end
            end
            if length(possible_ingredients) == 1
                solved[unsolved_allergen] = only(possible_ingredients)
            else
                still_unsolved[unsolved_allergen] = possible_ingredients
            end
        end
        unsolved = still_unsolved
    end

    return solved
end

function extract_safe_ingredients(solved_allergens::Dict{String, String}, foods::Vector{Food})
    safe_ingredients = String[]
    safe_ingredients_count = 0
    for food in foods
        for ingredient in food.ingredients
            if ingredient ∉ values(solved_allergens) && ingredient ∉ safe_ingredients
                push!(safe_ingredients, ingredient)
            end
        end
    end
    return safe_ingredients
end

function count_safe_ingredients(solved_allergens::Dict{String, String}, foods::Vector{Food})
    safe_ingredients = extract_safe_ingredients(solved_allergens, foods)
    safe_ingredients_count = 0


    for food in foods
        for i in food.ingredients
            if i ∉ values(solved_allergens)
                safe_ingredients_count += 1
            end
        end
    end
    return safe_ingredients_count


    @info safe_ingredients

    countmap = Dict{String, Int}(i => 0 for i in safe_ingredients)
    for food in foods
        for ingredient in food.ingredients
            if ingredient ∈ safe_ingredients
                countmap[ingredient] += 1
            end
        end
    end
    # @info countmap
    @info sum(length(food.ingredients) for food in foods) - sum(i for (_, i) in countmap)

    for food in foods
        for ingredient in food.ingredients
            if ingredient ∉ safe_ingredients
                safe_ingredients_count += 1
            end
        end
    end
    return sum(count(∈(safe_ingredients), food.ingredients) for food in foods)
    return safe_ingredients_count
end
count_safe_ingredients(foods::Vector{Food}) = 
    count_safe_ingredients(solve_allergens(foods), foods)

function part1(input_file::String)
    foods = parse_input(input_file)
    count_safe_ingredients(foods)
end

println(part1("inputs/data21.txt"))
# @assert(part1("inputs/test21.txt") == 5")
# @assert(part1("inputs/data21.txt") < 2295)
# @assert(part1("inputs/data21.txt") > 233)
# @assert(part1("inputs/data21.txt") == 2262)

### Part 2

function part2(input_file::String)
    error("not implemented")
end



input_file = "inputs/test21.txt"
# println(part1(input_file))
# println(part2(input_file))
