module CommonAppVersions

using VersionParsing
using HTTP
using Gumbo
using AbstractTrees

export get_latest_version
export Windows, MacOS, Linux
export Firefox, Chrome, Adobe, TeamViewer, Office2007,
    Office2010, Office2013, Office2016, Office365,
    Edge
export COMMON_APPLICATIONS

include("common.jl")
include("firefox.jl")
include("chrome.jl")
include("office.jl")
include("adobe.jl")
include("teamviewer.jl")
include("edge.jl")

"""
    get_latest_version(::CommonApplication, ::OperatingSystem = Windows)::VersionNumber

Get latest app version for common applications.

Supported common applications are in `COMMON_APPLICATIONS`.
"""
get_latest_version(app::CommonApplication, os::OS = Windows) where {OS <: OperatingSystem} =
    _get_latest_version(app, os)

const COMMON_APPLICATIONS = Dict{String, CommonApplication}(
    "Mozilla Firefox" => Firefox,
    "Google Chrome" => Chrome,
    "Adobe Acrobat DC" => Adobe,
    "Team Viewer" => TeamViewer,
    "Microsoft Office 2007" => Office2007,
    "Microsoft Office 2010" => Office2010,
    "Microsoft Office 2013" => Office2013,
    "Microsoft Office 2016" => Office2016,
    "Microsoft Office 365" => Office365,
    "Microsoft Edge" => Edge,
)

end
