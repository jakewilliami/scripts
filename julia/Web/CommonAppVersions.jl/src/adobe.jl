const ADOBE_URI = "https://www.adobe.com/devnet-docs/acrobatetk/tools/ReleaseNotesDC/index.html"

struct AdobeSingleton <: CommonApplication end
const Adobe = AdobeSingleton()

function _get_latest_version(::AdobeSingleton, ::WindowsOperatingSystem)
    r = HTTP.get(ADOBE_URI)
    doc = Gumbo.parsehtml(String(r.body))
    elem = _findfirst_html_tag(doc, "id", "continuous-track-installers")
    versions = elem.children[3].children
    v_info = versions[1].children[1].children[1].children[1].children[1].text    
    v_str = SubString(v_info, 1, prevind(v_info, findfirst(' ', v_info)))
    return VersionNumber(_reduce_version_major_minor_micro(v_str))
end
