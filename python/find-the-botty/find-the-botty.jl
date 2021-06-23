const BOTTY_DIR_TRANSCRIBED = joinpath("/", "Volumes", "old-data", "Jake's Stuff", "NSTAAF", "transcribed")

function search_for_botty(search_term::AbstractString)
    res_files = String[]
    for f in readdir(BOTTY_DIR_TRANSCRIBED)
        startswith(f, "._") && continue # weird temporary files
        if occursin(search_term, lowercase(read(joinpath(BOTTY_DIR_TRANSCRIBED, f), String)))
            filename, _ = splitext(f)
            push!(res_files, filename)
        end
    end
    
    return res_files
end

function main(search_terms::AbstractString...)
    res = Dict{String, String}()
    for s in search_terms
        search_res = search_for_botty(s)
        if !isempty(search_res)
            res[s] = join(search_res, ", ")
        end
    end
    
    return res
end

[println(p) for p in main("botty", "slap", "walked in")]
