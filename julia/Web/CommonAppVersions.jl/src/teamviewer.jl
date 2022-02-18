const TEAMVIEWER_URI = "https://www.teamviewer.com/en-us/download/windows/"  # "mac-os", "windows", "linux"
const TEAMVIEWER_REGEX = r"Current version\: ((?:\d+\.)?(?:\d+\.)?(?:\d+))"  # not quite as complex as Base.VERSION_REGEX

struct TeamViewerSingleton <: CommonApplication end
const TeamViewer = TeamViewerSingleton()

function get_latest_version(::TeamViewerSingleton)
    r = HTTP.get(TEAMVIEWER_URI)
    body = String(r.body)
    # doc = Gumbo.parsehtml(body)
    # elem = _findfirst_html_tag(doc, "id", "wd-row-download-win")
    # v_str = elem.parent.children[5].children[1].children[1].children[1].text
    m = match(TEAMVIEWER_REGEX, body)
    v_str = only(m.captures)
    return VersionNumber(_reduce_version_major_minor_micro(v_str))
end