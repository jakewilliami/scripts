using JSON

include(joinpath(dirname(@__DIR__), "src", "Anagrams.jl"))

@enum CountryCode AE AF AL AO AR AT AZ BD BE BF BG BH BI BN BO BR BW CA CH CL CM CN CO CR CY CZ DE DJ DK DZ EC EE EG ES ET FI FJ FR GB GE GH GR GT HK HN HR HT HU ID IE IL IN IQ IR IS IT JM JO JP KH KR KW KZ LB LT LU LY MA MD MO MT MU MV MX MY NA NG NL NO OM PA PE PH PL PR PS PT QA RS RU SA SD SE SG SI SV SY TM TN TR TW US UY YE ZA

abstract type AssociatedNameData end

struct CountryData <: AssociatedNameData
    data::Dict{CountryCode, Float64}
end

@enum GenderCode MALE FEMALE

_parse_gender_code(s::String) = s == "M" ? MALE : s == "F" ? FEMALE : error("Unknown gender code \"$s\"")

struct GenderData <: AssociatedNameData
    data::Dict{GenderCode, Float64}
end

struct RankData <: AssociatedNameData
    data::Dict{CountryCode, Int}
end

struct NameData
    name::String
    country::CountryData
    gender::GenderData
    rank::RankData
end

_NAME_DATA_INSTANCE_TYPE = Pair{String, Any}
_NAME_ASSOCIATED_DATA_INSTANCE_TYPE = Pair{String, Dict{String, Any}}

function _parse_associated_name_data(raw_data::_NAME_ASSOCIATED_DATA_INSTANCE_TYPE, ret_type::Type{T}, code_type::Type{E}, num_type::Type{U}) where {T <: AssociatedNameData, E <: Enum, U <: Real}
    # Construct data dictionary
    data = Dict{E, U}()
    for (c, v) in last(raw_data)  # Only care about the data, not the name of the indicator
        # Determine the enum type
        e = nothing
        if ret_type == GenderData
            e = _parse_gender_code(c)
        else 
            e = eval(Symbol(c))
        end
        @assert(!isnothing(e), "100% Julia Bug")
        
        # Check value type
        @assert(v isa U, "Unexpected type: $v has unexpected type: expected $U, found $(typeof(v))")
        
        # Add to data dictionary
        data[e] = v
    end
    
    return ret_type(data)
end

parse_country_data(raw_country_data::_NAME_ASSOCIATED_DATA_INSTANCE_TYPE) = 
    _parse_associated_name_data(raw_country_data, CountryData, CountryCode, Float64)

parse_gender_data(raw_gender_data::_NAME_ASSOCIATED_DATA_INSTANCE_TYPE) = 
    _parse_associated_name_data(raw_gender_data, GenderData, GenderCode, Float64)

parse_rank_data(raw_rank_data::_NAME_ASSOCIATED_DATA_INSTANCE_TYPE) = 
    _parse_associated_name_data(raw_rank_data, RankData, CountryCode, Int)

function parse_name_data(raw_name_data::_NAME_DATA_INSTANCE_TYPE)
    name, associated_name_data = raw_name_data
    return NameData(name,
                    parse_country_data("country" => associated_name_data["country"]),
                    parse_gender_data("gender" => associated_name_data["gender"]),
                    parse_rank_data("rank" => associated_name_data["rank"]),
                    )
end

_NAMES_DATA_DIR = joinpath("data", "names")
_FIRST_NAMES_DATA_RAW = JSON.parsefile(joinpath(_NAMES_DATA_DIR, "first_names.json"))
FIRST_NAMES_DATA = (parse_name_data(n) for n in _FIRST_NAMES_DATA_RAW)
_FIRST_NAMES_DATA_RAW = nothing
_LAST_NAMES_DATA_RAW = JSON.parsefile(joinpath(_NAMES_DATA_DIR, "last_names.json"))
LAST_NAMES_DATA = (parse_name_data(n) for n in _LAST_NAMES_DATA_RAW)
_LAST_NAMES_DATA_RAW = nothing

