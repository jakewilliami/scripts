# NOTE: the bleeding edge release versions seem to be found on https://community.teamviewer.com/English/categories/change-logs-en
const TEAMVIEWER_URI = "https://www.teamviewer.com/en-us/download/"
# const TEAMVIEWER_REGEX = r"Current version\: ((?:\d+\.)?(?:\d+\.)?(?:\d+))"  # not quite as complex as Base.VERSION_REGEX
const TEAMVIEWER_OS_SUFFIXES = Dict{OperatingSystem, String}(
    Windows => "windows/",
    MacOS => "mac-os/",
    Linux => "linux/",
)
const TEAMVIEWER_OS_KEYS = Dict{OperatingSystem, String}(
    Windows => "win",
    MacOS => "osx",
    Linux => "linux",
)

struct TeamViewerSingleton <: CommonApplication end
const TeamViewer = TeamViewerSingleton()

function _get_latest_version(::TeamViewerSingleton, os::OS) where {OS <: OperatingSystem}
    r = HTTP.get(TEAMVIEWER_URI * TEAMVIEWER_OS_SUFFIXES[os])
    body = String(r.body)
    doc = Gumbo.parsehtml(body)

    # Version 1
    # elem = _findfirst_html_tag(doc, "id", "wd-row-download-win")
    # v_str = onlychild(elem.parent.children[5].children[1].children[1]).text

    # Version 2
    # m = match(TEAMVIEWER_REGEX, body)
    # v_str = only(m.captures)

    # Version 3:
    # elem = _findfirst_html_tag(doc.root, "data-dl-version-label" => "", tag = :span)
    # v_str = onlychild(elem).text

    # Version 4
    elem = _findfirst_html_tag(doc.root, "class" => "cmp-smartdownloadbutton__wrapper", tag = :div, exact = true)
    data = JSON3.parse(elem.attributes["data-json"])
    tbl = only(data[:data])
    # sanity check for OS
    expected_os, found_os = TEAMVIEWER_OS_KEYS[os], tbl[:operatingSystem]
    @assert expected_os == found_os "Output validation error: $(repr(expected_os)) ≠ $(repr(found_os))"
    v_str = tbl[:versionNumber]

    return vparse(v_str)
end
