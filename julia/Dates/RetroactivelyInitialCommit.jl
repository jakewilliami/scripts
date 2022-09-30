# Author: Jake W. Ireland
# Date: Monday, 19th September, 2022
# Usage: julia RetroactivelyInitialCommit.jl <dir>
# Description: This script is designed to recurse
#   through a directory that has been previously
#   written to as if it were a git repository.
#   As the given directory was _not_ a git repo, 
#   this script aims to add an initial, retroactive
#   commit at the file's *creation* time, as long
#   as the file is not ignored by git.
#   In future, we should add an option to allow
#   this initial commit to be committed at the date
#   it was last modified.
# 
# Ported from ../Other/ (16ed1ec7).

using Dates

@enum CommitTime begin
    file_creation
    file_modification
end

function execute(cmd::C) where {C <: Base.AbstractCmd}
    io = IOBuffer()
    run(pipeline(cmd, stdout = io))
    return String(take!(io))
end

function isgitignored(f::AbstractString)
    cmd = Cmd(`git check-ignore "$f"`)
    try
        return !isempty(execute(cmd))
    catch ErrorException
        return false
    end
end

get_relative_days(dt::TimeType) = "$((today() - dt).value) days ago"
get_relative_days(f::Float64) = get_relative_days(Date(unix2datetime(f)))

function ingitdir(d::AbstractString)
    for p in splitpath(abspath(d))
        p == ".git" && return true
    end
    return false
end

function _get_all_files(d::AbstractString)
    A = String[]
    for (root, dirs, files) in walkdir(d)
        ingitdir(root) && continue
        append!(A, joinpath.(root, files))
    end
    return A
end

function get_all_files(d::AbstractString; ignore_ignored::Bool = true)
    A = _get_all_files(d)
    return ignore_ignored ? String[a for a in A if !isgitignored(a)] : A
end

function construct_cmd_map(d::AbstractString, ignore_ignored::Bool = true, commit_time::CommitTime = file_creation)
    A = get_all_files(d, ignore_ignored = ignore_ignored)
    D = Dict{String, Base.AndCmds}()
    for a in A
        s = stat(a)
        t = commit_time == file_creation ? s.ctime : commit_time == file_modification ? s.mtime : error("unhandled commit time type")
        ds = get_relative_days(t)
        cmd1 = `git add "$a"`
        cmd2 = `git commit --date="$ds" -m "Retroactive commit: initial commit of $(basename(a))"`
        D[a] = pipeline(cmd1 & cmd2)
    end
    return D
end

function main(d::AbstractString, ignore_ignored::Bool = true, commit_time::CommitTime = file_creation)
    cd(d) do
        D = construct_cmd_map(".", ignore_ignored, commit_time)  # we are in the directory now
        for (f, c) in D
            basename(f) == ".gitignore" && continue  # ignore .gitignored -- already committed
            try
                choice_str = "Do you want to run the following command? [y/N]"
                choice_str *= "\n"
                choice_str *= string(c.a)
                choice_str *= " && "
                choice_str *= string(c.b)
                choice = Base.prompt(choice_str) in ("y","Y") ? true : false
                if choice
                    c1 = run(c.a)
                    println(c1)
                    iszero(c1.exitcode) && run(c.b)
                end
                choice && run(c)
                println()
            catch
                println("ERROR: an error occurred")
            end
        end
    end
end

main(ARGS[1])
