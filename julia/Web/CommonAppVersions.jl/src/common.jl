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

function _findfirst_html_tag(doc::Gumbo.HTMLDocument, tag::String, value::String; alg::Type{T} = PreOrderDFS) where {T <: TreeIterator}
    for elem in alg(doc.root)
        if elem isa HTMLElement && getattr(elem, tag, "") == value
            return elem
        end
    end
    return nothing
end
