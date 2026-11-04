# NOTE: the bleeding edge release versions seem to be found on https://community.teamviewer.com/English/categories/change-logs-en
const TEAMVIEWER_URI = "https://www.teamviewer.com/en-us/download/"
# const TEAMVIEWER_REGEX = r"Current version\: ((?:\d+\.)?(?:\d+\.)?(?:\d+))"  # not quite as complex as Base.VERSION_REGEX
const TEAMVIEWER_OS_SUFFIXES = Dict{OperatingSystem, String}(
    Windows => "windows/",
    MacOS => "macos/",  # mac and mac-os redirect to this
    Linux => "linux/",
)
const TEAMVIEWER_OS_KEYS = Dict{OperatingSystem, String}(
    Windows => "Windows",
    MacOS => "macOS",
    Linux => "Linux",
)

struct TeamViewerSingleton <: CommonApplication end
const TeamViewer = TeamViewerSingleton()

function _get_latest_version(::TeamViewerSingleton, os::OS) where {OS <: OperatingSystem}
    r = HTTP.get(TEAMVIEWER_URI * TEAMVIEWER_OS_SUFFIXES[os])
    body = String(r.body)

    # Version 5: a very gross update for early November 2026, in which we now have to
    #   pull the version from embedded Next.js script data
    #
    # See previous versions at:
    #   github.com/jakewilliami/scripts/tree/d2f6bc2/julia/Web/CommonAppVersions.jl/src/teamviewer.jl

    # They are hiding the information in a blob of data in a script tag!!!
    #
    # We are sure to anchor the correct blob on the full client rather than the QuickSupport
    # (QS) version
    rx = r"""TeamViewerfullclient"\}\},"operatingSystem":\{"targetItem":\{"name":"(\w+)"\}\},"versionNumber":\{"value":"([\d.]+)"""

    # Match on Next.js data blobs
    for m in eachmatch(r"self\.__next_f\.push\((\[.*?\])\)"s, body)
        occursin("versionNumber", m.captures[1]) || continue
        decoded = JSON.parse(m.captures[1])[2]

        # Find the data containing the version information we need
        m = match(rx, decoded)
        m === nothing && continue
        found_os, v_str = m.captures

        # Sanity check for OS
        expected_os = TEAMVIEWER_OS_KEYS[os]
        @assert lowercase(expected_os) == lowercase(found_os) "Output validation error: $(repr(expected_os)) ≠ $(repr(found_os))"

        return vparse(v_str)
    end

    error("no TeamViewer version found")
end
