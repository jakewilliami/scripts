abstract type CommonApplication end

abstract type OperatingSystem end
struct WindowsOperatingSystem <: OperatingSystem end
struct MacOSOperatingSystem <: OperatingSystem end
struct LinuxOperatingSystem <: OperatingSystem end
const Windows = WindowsOperatingSystem()
const MacOS = MacOSOperatingSystem()
const Linux = LinuxOperatingSystem()

Base.isempty(::T) where {T <: Gumbo.HTMLNode} = T == NullNode

onlychild(el::Gumbo.HTMLElement) = only(el.children)

function _findfirst_html_tag(doc::Gumbo.HTMLElement, attr_val::Union{Pair{String, String}, Pair{String, Regex}}; exact::Bool = true, tag::Union{Symbol, Nothing} = nothing, alg::Type{T} = PreOrderDFS) where {T <: TreeIterator}
    attr, value = attr_val
    for elem in alg(doc)
        elem isa HTMLElement || continue
        if !isnothing(tag)
            Gumbo.tag(elem) == tag || continue
        end
        el_attr = getattr(elem, attr, nothing)
        isnothing(el_attr) && continue
        (exact ? el_attr == value : contains(el_attr, value)) && return elem
    end
    return nothing
end

function _findfirst_html_text(doc::Gumbo.HTMLElement, tag::Symbol, text::Union{String, Regex}; exact::Bool = true, alg::Type{T} = PreOrderDFS) where {T <: TreeIterator}
    for elem in alg(doc)
        elem isa HTMLElement || continue
        if Gumbo.tag(elem) == tag
            el_text = Gumbo.text(elem)
            (exact ? el_text == text : contains(el_text, text)) && return elem
        end
    end
    return nothing
end

function _findfirst_html_class_text(doc::Gumbo.HTMLElement, attr_val::Union{Pair{String, String}, Pair{String, Regex}}, text::Union{String, Regex}; exact::Bool = true, tag::Union{Symbol, Nothing} = nothing, alg::Type{T} = PreOrderDFS) where {T <: TreeIterator}
    attr_name, value = attr_val
    for elem in alg(doc)
        elem isa HTMLElement || continue
        if !isnothing(tag)
            Gumbo.tag(elem) == tag || continue
        end
        all_attrs = Gumbo.attrs(elem)
        this_attr = get(all_attrs, attr_name, nothing)
        if this_attr == value
            el_text = Gumbo.text(elem)
            (exact ? el_text == text : contains(el_text, text)) && return elem
        end
    end
    return nothing
end

function _nextsibling(el::Gumbo.HTMLElement, j::Int = 1)
    parent = el.parent
    isempty(parent) && return nothing
    siblings = parent.children
    i = findfirst(==(el), siblings) + j
    return checkbounds(Bool, siblings, i) ? siblings[i] : nothing
end
