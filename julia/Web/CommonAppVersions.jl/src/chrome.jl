# Source: chromium.org/administrators/frequently-asked-questions/ @ "How do I know what the most current version of Google Chrome is for Windows?"
const CHROME_URI = "https://chromiumdash.appspot.com/"  # can also suffix with `history`
const CHROME_OS_SUFFIXES = Dict{OperatingSystem, String}(
    Windows => "win",
    MacOS => "mac",
    Linux => "linux",
)

struct ChromeSingleton <: CommonApplication end
const Chrome = ChromeSingleton()

function _get_latest_version(::ChromeSingleton, os::OperatingSystem)
    r = HTTP.get(CHROME_URI * CHROME_OS_SUFFIXES[os])
    v_str = String(r.body)
    return vparse(v_str)
end
