const ADOBE_URI = "https://www.adobe.com/devnet-docs/acrobatetk/tools/ReleaseNotesDC/index.html"

struct AdobeSingleton <: CommonApplication end
const Adobe = AdobeSingleton()

function _get_latest_version(::AdobeSingleton, ::WindowsOperatingSystem)
    r = HTTP.get(ADOBE_URI,  [
        "Sec-Ch-Ua" => "\" Not A;Brand\";v=\"99\", \"Chromium\";v=\"90\"",
        "Accept" => "application/json",
        "Sec-Ch-Ua-Mobile" => "?0",
        "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36",
        "Accept-Encoding" => "identity",
        "Sec-Fetch-Site" => "same-site",
        "Sec-Fetch-Mode" => "cors",
        "Sec-Fetch-Dest" => "empty",
        "Accept-Language" => "en-GB,en-US;q=0.9,en;q=0.8",
        "Connection" => "close"
    ])
    doc = Gumbo.parsehtml(String(r.body))
    elem = _findfirst_html_tag(doc.root, "id" => "continuous-track-installers", tag = :div)
    versions = _findfirst_html_tag(elem, "class" => "simple", tag = :ul).children
    # TODO: use regex instead of substrings here
    # Example of version listings:
    # 21.007.20095 (Win), 21.007.20096 (Mac) Optional update, Sept 29, 2021
    # 19.010.20100 Optional update, April 16, 2019 (Windows Only)
    # 19.010.20099 Planned update, April 09, 2019
    # 19.010.20098 Out of cycle update, February 21, 2019
    v_info = onlychild(_findfirst_html_tag(versions[1], "class" => "std std-ref", tag = :span)).text
    v_str = SubString(v_info, 1, prevind(v_info, findfirst(' ', v_info)))
    return vparse(v_str)
end
