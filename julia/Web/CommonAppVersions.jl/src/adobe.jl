const ADOBE_URI = "https://www.adobe.com/devnet-docs/acrobatetk/tools/ReleaseNotesDC/index.html"

struct AdobeSingleton <: CommonApplication end
const Adobe = AdobeSingleton()

function _get_latest_version(::AdobeSingleton, ::WindowsOperatingSystem)
    r = HTTP.get(ADOBE_URI)
    doc = Gumbo.parsehtml(String(r.body))
    elem = _findfirst_html_tag(doc.root, "id" => "continuous-track-installers", tag = :div)
    versions = _findfirst_html_tag(elem, "class" => "simple", tag = :ul).children
    v_info = onlychild(_findfirst_html_tag(versions[1], "class" => "std std-ref", tag = :span)).text
    v_str = SubString(v_info, 1, prevind(v_info, findfirst(' ', v_info)))
    return VersionNumber(_reduce_version_major_minor_micro(v_str))
end
