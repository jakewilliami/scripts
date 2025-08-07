# Source: chromium.org/administrators/frequently-asked-questions/ @ "How do I know what the most current version of Google Chrome is for Windows?"
# NOTE: as of September, 2023, omahaproxy.appspot.com is no longer
const CHROME_URI = "https://chromiumdash.appspot.com/"
const CHROME_URI_PAGE = "fetch_releases"
const CHROME_OS_SUFFIXES = Dict{OperatingSystem, String}(
    Windows => "win",
    MacOS => "mac",
    Linux => "linux",
)

struct ChromeSingleton <: CommonApplication end
const Chrome = ChromeSingleton()

function _get_latest_version(::ChromeSingleton, os::OperatingSystem)
    # https://stackoverflow.com/a/70953552
    params = Dict{String, Union{String, Int}}(
        "channel" => "Stable",
        "platform" => CHROME_OS_SUFFIXES[os],
        "num" => 1,
    )
    r = HTTP.get(CHROME_URI * CHROME_URI_PAGE, query = params)
    j = only(JSON3.parse(String(r.body)))
    v_str = j["version"]
    return vparse(v_str)
end
