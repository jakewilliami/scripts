module CommonAppVersions

using HTTP
using Gumbo
using EzXML
using AbstractTrees

export get_latest_version
export Firefox, Chrome, Adobe, TeamViewer, Office2007,
    Office2010, Office2013, Office2016, Office365
export COMMON_APPLICATIONS

abstract type CommonApplication end

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

function _findfirst_html_id(doc::Gumbo.HTMLDocument, id::String)
    for elem in PreOrderDFS(doc.root)
        if elem isa HTMLElement && getattr(elem, "id", "") == id
            return elem
        end
    end
    return nothing
end

include("firefox.jl")
include("chrome.jl")
include("office.jl")
include("adobe.jl")
include("teamviewer.jl")

"""
    get_latest_version(::CommonApplication)::VersionNumber

Get latest app version for common applications.

Supported common applications are in `COMMON_APPLICATIONS`.
"""
function get_latest_version end

const COMMON_APPLICATIONS = Dict{String, CommonApplication}(
    "Mozilla Firefox" => Firefox,
    "Google Chrome" => Chrome,
    # "Adobe Acrobat DC" => Adobe,
    "Team Viewer" => TeamViewer,
    # "Microsoft Office 2007" => Office2007,
    # "Microsoft Office 2010" => Office2010,
    # "Microsoft Office 2013" => Office2013,
    # "Microsoft Office 2016" => Office2016,
    # "Microsoft Office 365" => Office365,
)

end
