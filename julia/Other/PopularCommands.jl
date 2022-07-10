using OrderedCollections

function main()
    D = Dict{String, Int}()
    for l in readlines(joinpath(homedir(), ".bash_history"))
        commands_full = split(l, ('&', ';'))
        command_stubs = (strip(split(c, limit=1)) for c in commands_full)
        for c in commands_full
            c = strip(c)
            isempty(c) && continue
            c = first(split(c, limit=2))
            D[c] = get(D, c, 0) + 1
        end
    end
    D′ = sort(D, byvalue=true, rev=true)
    return D′
end

println(main())
