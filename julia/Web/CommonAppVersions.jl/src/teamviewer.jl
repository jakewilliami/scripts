const TEAMVIEWER_URI = "https://www.teamviewer.com/en-us/download/"
const TEAMVIEWER_REGEX = r"Current version\: ((?:\d+\.)?(?:\d+\.)?(?:\d+))"  # not quite as complex as Base.VERSION_REGEX
const TEAMVIEWER_OS_SUFFIXES = Dict{OperatingSystem, String}(
    Windows => "windows/",
    MacOS => "mac-os/",
    Linux => "linux/",
)

struct TeamViewerSingleton <: CommonApplication end
const TeamViewer = TeamViewerSingleton()

function _get_latest_version(::TeamViewerSingleton, os::OS) where {OS <: OperatingSystem}
    r = HTTP.get(TEAMVIEWER_URI * TEAMVIEWER_OS_SUFFIXES[os])
    body = String(r.body)
    # doc = Gumbo.parsehtml(body)
    # elem = _findfirst_html_tag(doc, "id", "wd-row-download-win")
    # v_str = elem.parent.children[5].children[1].children[1].children[1].text
    m = match(TEAMVIEWER_REGEX, body)
    v_str = only(m.captures)
    return VersionNumber(_reduce_version_major_minor_micro(v_str))
end

function _get_latest_version(::TeamViewerSingleton, ::LinuxOperatingSystem)
    throw(ArgumentError("Linux not yet supported for TeamViewer, as the Linux TeamViewer page has multiple versions depending on arch/dist"))
end
