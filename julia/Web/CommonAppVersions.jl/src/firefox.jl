const FIREFOX_URI = "https://www.mozilla.org/"

struct FirefoxSingleton <: CommonApplication end
const Firefox = FirefoxSingleton()

function get_latest_version(::FirefoxSingleton)
    r = HTTP.get(FIREFOX_URI)
    doc = parsehtml(String(r.body))
    v_str = doc.root.attributes["data-latest-firefox"]
    return VersionNumber(v_str)
end
