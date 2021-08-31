using Colors

const BLUE = RGB(0, 0, 1)

function calculate_colour_distance(C1::AbstractRGB, C2::AbstractRGB)
    x = (C2.r - C1.r) ^ 2
    y = (C2.g - C1.g) ^ 2
    z = (C2.b - C1.b) ^ 2
    return sqrt(x + y + z)
end

#=function calculate_colour_distance2(C1::RGB, C2::RGB)
    res = 0.0
    for t in fieldnames(RGB)
        @eval tmp = (C2.$t - C1.$t) ^ 2
        res += tmp
    end
    return sqrt(res)
end=#

_append_hash_as_required(S::AbstractString) = startswith(S, '#') ? S : string('#', S)

function calculate_colour_distance(C1::AbstractString, C2::AbstractString)
    C1 = _append_hash_as_required(C1)
    C2 = _append_hash_as_required(C2)
    return calculate_colour_distance(parse(RGB, C1), parse(RGB, C2))
end
function calculate_colour_distance(C1::AbstractRGB, C2::AbstractString)
    C2 = _append_hash_as_required(C2)
    return calculate_colour_distance(C1, parse(RGB, C2))
end
function calculate_colour_distance(C1::AbstractString, C2::AbstractRGB)
    C1 = _append_hash_as_required(C1)
    return calculate_colour_distance(parse(RGB, C1), C2)
end

_rf_findmin((fm, im), (fx, ix)) = Base.isgreater(fm, fx) ? (fx, ix) : (fm, im)
_argmin(f, domain) = mapfoldl(x -> (f(x), x), _rf_findmin, domain)[2]

function closest_to_blue(colours::Vector{T}) where {T <: Union{AbstractRGB, AbstractString}}
    return _argmin(c -> calculate_colour_distance(BLUE, c), colours)
    # return colours[last(findmin(Float64[calculate_colour_distance(BLUE, c) for c in colours]))]
end

