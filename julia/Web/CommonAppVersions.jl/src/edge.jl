const EDGE_URI = "https://docs.microsoft.com/en-us/deployedge/microsoft-edge-relnote-stable-channel"
const EDGE_VERSION_ID_REGEX = r"version-(?:\d+)-(?:january|february|march|april|may|june|july|august|september|october|november|december)-(?:\d{1,3})"
const EDGE_VERSION_REGEX = r"Version ((?:\d+\.)?(?:\d+\.)?(?:\d+\.)?(?:\d+))\: (?:January|February|March|April|May|June|July|August|September|October|November|December) (?:\d{1,2})"

struct EdgeSingleton <: CommonApplication end
const Edge = EdgeSingleton()

function _get_latest_version(::EdgeSingleton, ::OperatingSystem)
    r = HTTP.get(EDGE_URI)
    doc = Gumbo.parsehtml(String(r.body))
    elem = _findfirst_html_tag(doc.root, "id" => EDGE_VERSION_ID_REGEX, tag = :h2, exact = false)
    v_info = onlychild(elem).text
    m = match(EDGE_VERSION_REGEX, v_info)
    v_str = only(m.captures)
    return vparse(v_str)
end
