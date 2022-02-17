const TEAMVIEWER_URI = "https://www.teamviewer.com/en-us/download/windows/"
# "mac-os", "windows"

struct TeamViewerSingleton <: CommonApplication end
const TeamViewer = TeamViewerSingleton()

function get_latest_version(::TeamViewerSingleton)
    r = HTTP.get(TEAMVIEWER_URI)
    body = String(r.body)
    rx = r"Current version\: ((?:\d+\.)?(?:\d+\.)?(?:\d+))"  # Base.VERSION_REGEX
    m = match(rx, body)
    v_str = only(m.captures)
    return VersionNumber(v_str)
    # doc = parsehtml(String(r.body))
end
