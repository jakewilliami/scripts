module CommonAppVersions

# using HTTP, EzXML
using HTTP, Gumbo

export get_latest_version
export Firefox, TeamViewer

abstract type CommonApplication end

include("firefox.jl")
include("chrome.jl")
include("office.jl")
include("teamviewer.jl")

"""
    get_latest_version(::CommonApplication)

Get latest app version for common applications.
"""
function get_latest_version end

end
