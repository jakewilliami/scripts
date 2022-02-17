module CommonAppVersions

# using HTTP, EzXML
using HTTP, Gumbo

export get_latest_version
export Firefox

abstract type CommonApplication end

include("firefox.jl")

"""
    get_latest_version(::CommonApplication)

Get latest app version for common applications.
"""
function get_latest_version end

end
