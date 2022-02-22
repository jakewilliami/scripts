const FIREFOX_URI = "https://www.mozilla.org/"

struct FirefoxSingleton <: CommonApplication end
const Firefox = FirefoxSingleton()

function _get_latest_version(::FirefoxSingleton, ::OperatingSystem)
    # I believe the "desktop" version of Firefox is consistent across OSs
    r = HTTP.get(FIREFOX_URI)
    doc = Gumbo.parsehtml(String(r.body))
    v_str = doc.root.attributes["data-latest-firefox"]
    return vparse(v_str)
end
