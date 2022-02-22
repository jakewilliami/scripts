abstract type CommonApplication end

abstract type OperatingSystem end
struct WindowsOperatingSystem <: OperatingSystem end
struct MacOSOperatingSystem <: OperatingSystem end
struct LinuxOperatingSystem <: OperatingSystem end
const Windows = WindowsOperatingSystem()
const MacOS = MacOSOperatingSystem()
const Linux = LinuxOperatingSystem()

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

Base.isempty(::T) where {T <: HTMLNode} = T == NullNode

function _findfirst_html_tag(doc::Gumbo.HTMLElement, attr::String, value::String; exact::Bool = true, alg::Type{T} = PreOrderDFS) where {T <: TreeIterator}
    for elem in alg(doc)
        elem isa HTMLElement || continue
        el_attr = getattr(elem, attr, "")
        (exact ? el_attr == value : contains(el_attr, value)) && return elem
    end
    return nothing
end

function _findfirst_html_text(doc::Gumbo.HTMLElement, tag::Symbol, text::String; exact::Bool = true, alg::Type{T} = PreOrderDFS) where {T <: TreeIterator}
    for elem in alg(doc)
        elem isa HTMLElement || continue
        if Gumbo.tag(elem) == tag
            el_text = Gumbo.text(elem)
            (exact ? el_text == text : contains(el_text, text)) && return elem
        end
    end
    return nothing
end

function _nextsibling(el::Gumbo.HTMLElement)
    parent = el.parent
    isempty(parent) && return nothing
    siblings = parent.children
    i = findfirst(==(el), siblings) + 1
    return checkbounds(Bool, siblings, i) ? siblings[i] : nothing
end

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
