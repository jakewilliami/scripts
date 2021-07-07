# http://www.mandylionlabs.com/documents/BFTCalc.xls

function get_case_count(s::AbstractString, case_type::Symbol)
    case_func = identity
    if case_type == :lower
        case_func = islower
    elseif case_type == :upper
        case_func = isupper
    end
    
    case_count = 0
    for c in s
        if case_func(c)
            case_count += 1
        end
    end
    
    return case_count
end

for f in (:lower, :upper)
    f_func = Symbol("$(f)case")
    new_f_func = Symbol("is$(f)")
    @eval new_f_func(c::AbstractChar) = c == f_func(c)
    count_func = Symbol("get_$(f)_count")
    @eval count_func(s::AbstractString) = get_case_count(s, f)
end

function get_numeric_count(s::AbstractString)
    numeric_count = 0
    for c in s
        if isdigit(c)
            numeric_count += 1
        end
    end
    
    return numeric_count
end

function get_special_count(s::AbstractString)
    special_count = 0
    for c in s
        if !isletter(c) && !isdigit(c)
            special_count += 1
        end
    end
    
    return special_count
end


function get_entropy(s::AbstractString)

# average_cracking_time(string_entropy::Number, guess_rate::Number) = 0.5 * 2^string_entropy / guess_rate


function main()
    checks_per_second = 1
    
    # obtain password
    pass::Base.SecretBuffer = Base.getpass("Please enter your password a strength check")
    
    brute_length = 0
    

    # wipe the secret buffer!
    Base.shred!(pass)
    
    return brute_length
end

main()
