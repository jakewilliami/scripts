using HTTP, SHA

"""
```julia
format_number_from_string(number::AbstractString) -> String
format_number_from_string(number::AbstractString, delimiter::Char) -> String
```

This function will take in a string, and comma-separate it as if it were a number.  You can also pass it a delimiter instead of the default comma.

This function was chosen because it runs much much faster than parsing the output of the API call as an integer and then using pre-written tools to format that.  As we are not using the number of times your password has been leaked as an integer, the decision was made to keep it as a string (`SubString` to be exact) and format it from there.
"""
function format_number_from_string(number::AbstractString, delimiter::Char)
    ret = ""

    for i in length(number):-1:1
        if (mod(length(number) - i, 3) == 0) && (i != length(number))
            ret = delimiter * ret
        end

        ret = number[i] * ret
    end

    return ret
end
format_number_from_string(number::AbstractString) = format_number_from_string(number, ',')

"""
```julia
get_similar_hashes(prefix::String) -> Dict{String, SubString}
```

This function will take in the first 5 characters of a SHA1-hashed password (as `prefix`) call the pwned API.

This will return a dictionary of complete hashes whose first 5 characters match your input prefix, and their corresponding occurrences in leaked databases (as `SubStrings`, not `Integer`s).
"""
function get_similar_hashes(prefix::String, URL::String)
    response::HTTP.Messages.Response = HTTP.request(:GET, URL * '/' * prefix)
    
    if response.status != 200
        @error "API call failed!"
    end

    body_vec::Vector{UInt8} = response.body
    body_str::String = String(body_vec)
    body_strs::Vector{SubString} = split(body_str, "\r\n")

    hash_dict::Dict{String, SubString} = Dict{String, SubString}()
    for r in body_strs
        h, n = split(r, ':')
        push!(hash_dict, prefix * h => n)
    end

    return hash_dict
end
get_similar_hashes(prefix::String) = get_similar_hashes(prefix, "https://api.pwnedpasswords.com/range/")

"""
```julia
hash_password(password::String) -> String
```

Hashes the password from plaintext input.
"""
function hash_password(password::String)
    return uppercase(bytes2hex(sha1(password)))
end

"""
```julia
get_password_hash() -> String
```

This function gets the password from a request to a `SecretBuffer` object and returns its SHA1 hash.
"""
function get_password_hash()
    pass::Base.SecretBuffer = Base.getpass("Please enter your password for hashing")

    hash_vec::Vector{UInt8} = sha1(read(pass, String))
    # wipe the secret buffer!
    Base.shred!(pass)
    # turn hash into string
    hash_str::String = uppercase(bytes2hex(hash_vec))

    return hash_str
end

"""
```julia
format_response(hash::String) -> String
```

Takes in a hash, performs the API call using `get_similar_hashes`, and formats the result.
"""
function format_response(hash::String)
    # get just the prefix
    prefix::String = hash[1:5]

    # get similar hashes
    responses::Dict{String, SubString} = get_similar_hashes(prefix)
    times_pwned::String = format_number_from_string(get(responses, hash, 0))
    
    return "Your password has been leaked $(times_pwned) times!"
end

"""
```julia
main() -> Nothing
main(io::IO) -> Nothing
```

The main function will securely ask for a password, hash it using SHA1, and determine if your password has been leaked any times.  It will print the result to `io`.  `io` will default to `stdout` if not specified.

This will prompt you for a password, or you can give it passwords from stdin:
```bash
cat passwords.txt | julia PwnedAPICall.jl
```

You can also pass it one or more files:
```bash
julia PwnedAPICall.jl passwords1.txt passwords2.txt
```
"""
function main(io::IO)
    if !isempty(ARGS) # if files are given
        # check that the user doesn't want help :sweat_smile:
        if ARGS[1] == "-h" || ARGS[1] == "--help"
            println("""
This script will use a pwned API call to see if your passwords have been leaked.

You may run one of the following:
    julia PwnedAPICall.jl
    cat passwords.txt | julia PwnedAPICall.jl
    julia PwnedAPICall.jl passwords.txt
            """)
            return nothing
        end
        # loop through the input files
        for f in ARGS
            for p in readlines(f)
                local hash::String = hash_password(p)
                local response::String = format_response(hash)
                println(io, response)
            end
        end
    elseif bytesavailable(STDIN) > 0 # check if stdin is given
        # if it is, loop through stdin passwords
        for p in readlines(stdin)
            local hash::String = hash_password(p)
            local response::String = format_response(hash)
            println(io, response)
        end
    else # no stdin or args given
        local hash::String = get_password_hash()
        local response::String = format_response(hash)
        println(io, response)
    end

    return nothing
end
main() = main(stdout)

main()

# Here's how to do it in bash:
# PASS=""; HASH="$(echo "$PASS" | sha1sum | awk '{print $1}')"; PREFIX="${HASH:0:5}"; curl -s "https://api.pwnedpasswords.com/range/$PREFIX" | grep "$HASH"
