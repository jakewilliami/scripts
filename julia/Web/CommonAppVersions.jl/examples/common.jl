using CommonAppVersions, InteractiveUtils
 
# We only care about major, minor, and micro
function _reduce_version_major_minor_micro(v_str::T) where {T <: AbstractString}
    n = count('.', v_str)
    n < 3 && return v_str
    i = findfirst('.', v_str)
    j = 1
    while j < 3
        k = findnext('.', v_str, nextind(v_str, i))
        j += 1
        i = k
    end
    reduced_v_str = SubString(v_str, 1, prevind(v_str, i))
    return String(reduced_v_str)
end
_reduce_version_major_minor_micro(v::VersionNumber) = join(getfield.(v, (:major, :minor, :patch)), '.')
 
function main()
    common_apps = [
        "Microsoft Office 2007",
        "Microsoft Office 2010",
        "Microsoft Office 2013",
        "Microsoft Office 2016",
        "Microsoft Office 365",
        "Team Viewer",
        "Google Chrome",
        "Mozilla Firefox",
        "Adobe Acrobat DC",
    ]
   
    io = IOBuffer()
    print(io, "<?php\n\n")
    print(io, raw"$LATEST_APPLICATION_VERSIONS = [")
    print(io, "\n")
   
    for app in common_apps
        v = get_latest_version(COMMON_APPLICATIONS[app])
        v_str_reduced =  _reduce_version_major_minor_micro(v)
        print(io, "    \"$app\" => \"$v_str_reduced\",\n")
    end
   
    print(io, "];\n")
 
    res = String(take!(io))
 
    clipboard(res)
    return res
end
 
println(main())
 
#=
treesize(node) = 1 + mapreduce(treesize, +, Gumbo.children(node), init=0)
treebreadth(node) = isempty(Gumbo.children(node)) ? 1 : mapreduce(treebreadth, +, Gumbo.children(node))
treeheight(node) = isempty(Gumbo.children(node)) ? 0 : 1 + mapreduce(treeheight, max, Gumbo.children(node))
 
# logic stolen from https://github.com/JuliaCollections/AbstractTrees.jl/blob/master/src/base.jl
# AbstractTrees.children(elem::HTMLElement) = elem.children
# AbstractTrees.children(elem::HTMLText) = ()
nodedepth(node) = isempty(node.parent) ? 0 : 1 + nodedepth(node.parent)
 
# Base.findfirst(f, doc::Gumbo.HTMLDocument; alg::Type{T} = PreOrderDFS) where {T <: TreeIterator} =
#     findfirst(f, [e for e in alg(doc.root)])
 
function Base.findfirst(f::Function, doc::Gumbo.HTMLDocument; alg::Type{T} = PreOrderDFS) where {T <: TreeIterator}
    # D = Dict{Tuple{HTMLNode, Int}, Int}()
    for e in alg(doc.root)
        # for each element, we want to see their position in regard to their parent
        # t = (e, nodedepth(e))
        # D[t] = get(D, t, 0) + 1
        f(e) && return findfirst(sibling -> sibling == e, e.parent.children)
    end
    return nothing
end
=#
