### Structs

struct Food
    ingredients::Set{String}
    allergens::Set{String}
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
            foods[i] = Food(Set(ingredients), Set(allergens))
        end        
    end
    return foods
end

### Finding safe ingredients

function all_allergens(foods::Vector{Food})
    return mapreduce(Base.Fix2(getproperty, :allergens),
        union, foods)
end

# Which ingredients might contain a specific allergen?
function candidate_ingredients(foods::Vector{Food}, allergen::String)
    related = Food[f for f in foods if allergen ∈ f.allergens]
    return intersect((r.ingredients for r ∈ related)...)
end

# Create a list of allergen => candidate ingredients
function create_work_list(foods::Vector{Food})
    return Dict{String, Set{String}}(a => candidate_ingredients(foods, a) 
        for a in all_allergens(foods))
end

# Resovle the work list.
# If an allergen is mapped to exactly one ingredient, then 
# it's resolved. Then, remove this ingredient from the work
# list. Repeat until all alergens are resolved.
function resolve(work_list::Dict{String, Set{String}})
    result = Dict{String, String}()
    queue = collect(keys(work_list))
    while length(result) < length(work_list)
        allergen = popfirst!(queue)
        if length(work_list[allergen]) == 1
            ingredient = only(work_list[allergen])
            result[allergen] = ingredient
            for k in keys(work_list) # remove from all others
                if k != allergen
                    delete!(work_list[k], ingredient)
                end
            end
        else
            push!(queue, allergen)
        end
    end
    return result
end

# Count how many ingredients are left after excluding the
# exclusion list.
function remaining_ingredients(foods::Vector{Food}, exclude_ingredients::Vector{String})
    cnt = 0
    for f in foods
        s = setdiff(f.ingredients, exclude_ingredients)
        cnt += length(s)
    end
    return cnt
end

function resolve_allergens(foods::Vector{Food})
    work_list = create_work_list(foods)
    return resolve(work_list)
end

function part1(input_file::String)
    foods = parse_input(input_file)
    mapped = resolve_allergens(foods)
    return remaining_ingredients(foods, collect(values(mapped)))
end

function part2(input_file::String)
    foods = parse_input(input_file)
    mapped = resolve_allergens(foods)
    return join([mapped[k] for k in sort(collect(keys(mapped)))], ",")
end

println(part1("inputs/data21.txt"))
println(part2("inputs/data21.txt"))
