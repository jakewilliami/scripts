module CommonAppVersions

# using HTTP, EzXML
using HTTP, Gumbo

export get_latest_version
export Firefox, Chrome, TeamViewer

abstract type CommonApplication end

# We only care about major, minor, and micro
function _reduce_version_major_minor_micro(v_str::String)
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

include("firefox.jl")
include("chrome.jl")
include("office.jl")
include("adobe.jl")
include("teamviewer.jl")

"""
    get_latest_version(::CommonApplication)::VersionNumber

Get latest app version for common applications.
"""
function get_latest_version end

end
