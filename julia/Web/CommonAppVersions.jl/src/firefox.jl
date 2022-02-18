const FIREFOX_URI = "https://www.mozilla.org/"

struct FirefoxSingleton <: CommonApplication end
const Firefox = FirefoxSingleton()

function get_latest_version(::FirefoxSingleton)
    r = HTTP.get(FIREFOX_URI)
    doc = Gumbo.parsehtml(String(r.body))
    v_str = doc.root.attributes["data-latest-firefox"]
    return VersionNumber(_reduce_version_major_minor_micro(v_str))
end
