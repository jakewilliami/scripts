# Source: chromium.org/administrators/frequently-asked-questions/ @ "How do I know what the most current version of Google Chrome is for Windows?"
const CHROME_URI = "https://omahaproxy.appspot.com/win"
# `/mac`, or `/history | grep ...`

struct ChromeSingleton <: CommonApplication end
const Chrome = ChromeSingleton()

function get_latest_version(::ChromeSingleton)
    r = HTTP.get(CHROME_URI)
    v_str = _reduce_version_major_minor_micro(String(r.body))
    return VersionNumber(v_str)
end
