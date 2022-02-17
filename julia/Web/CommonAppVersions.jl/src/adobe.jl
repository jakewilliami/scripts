const ADOBE_URI = "https://www.adobe.com/devnet-docs/acrobatetk/tools/ReleaseNotesDC/index.html"

struct AdobeSingleton <: CommonApplication end
const Adobe = AdobeSingleton()

function get_latest_version(::AdobeSingleton)
    r = HTTP.get(ADOBE_URI)
    doc = parsehtml(String(r.body))
    # TODO: need to find the `link` tag near the top of the body whore `href` attribute is a link starting with `"/continuous"`, and we take the `title` tag and split by space, and take the first element
    return VersionNumber(v_str)
end
