const WINDOWS_10_URI = "https://learn.microsoft.com/en-us/windows/release-health/release-information"

# Types/structs

abstract type MicrosoftWindowsSingleton <: CommonApplication end

struct Windows10Singleton <: MicrosoftWindowsSingleton end
const Windows10 = Windows10Singleton()

# Version methods

function _get_latest_version(::Windows10Singleton, ::WindowsOperatingSystem)
    r = HTTP.get(WINDOWS_10_URI)
    doc = Gumbo.parsehtml(String(r.body))
    elem = _findfirst_html_tag(doc.root, "id" => "windows-10-release-history", tag = :h2)
    tbl = onlychild(_nextsibling(elem, 5))  # go to the 5th next element (the release table)
    tbl = tbl.children[2:end]  # skip the table header

    v_min = VersionNumber("0.0.0")
    v_max = maximum(tbl) do tr
        v_elem = onlychild(tr.children[3])  # the third column is the version number
        isempty(v_elem) ? v_min : vparse(v_elem.text)
    end

    # The patch version for Windows 10 comes from the major version of the build number!
    # This is similar to the Office 2016 version, which uses the build version as the
    # patch version!
    return vparse(join((10, 0, v_max), "."))
end

function _get_latest_version(::MicrosoftWindowsSingleton, ::OperatingSystem)
    throw(ArgumentError("Microsoft Windows is not supported for any other operating system, as it is itself a Windows operating system"))
end
