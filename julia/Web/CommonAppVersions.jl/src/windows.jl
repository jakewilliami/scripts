const WINDOWS_10_URI = "https://learn.microsoft.com/en-us/windows/release-health/release-information"
const WINDOWS_11_URI = "https://learn.microsoft.com/en-us/windows/release-health/windows11-release-information"

# Types/structs

abstract type MicrosoftWindowsSingleton <: CommonApplication end

struct Windows10Singleton <: MicrosoftWindowsSingleton end
struct Windows11Singleton <: MicrosoftWindowsSingleton end
const Windows10 = Windows10Singleton()
const Windows11 = Windows11Singleton()

# Version methods

function _get_latest_windows_10_version(uri::String, release_history_html_id::String)
    r = HTTP.get(uri)
    doc = Gumbo.parsehtml(String(r.body))

    ## 1. Get release table from page
    elem = _findfirst_html_tag(doc.root, "id" => release_history_html_id, tag = :h2)
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

function _get_latest_windows_11_version(uri::String, release_history_html_id::String)
    r = HTTP.get(uri)
    doc = Gumbo.parsehtml(String(r.body))

    ## 1. Get release table from page
    elem = _findfirst_html_tag(doc.root, "id" => release_history_html_id, tag = :h2)
    # tbl = onlychild(_nextsibling(elem, 5))  # go to the 5th next element (the release table)
    # tbl = tbl.children[2:end]  # skip the table header
    ### 1. a. Fix for November, 2024
    tbl = _nextsibling(elem, 6)  # go to the 6th next element (the release table)
    tbl = onlychild(tbl.children[3]).children[2:end]  # skip the table header

    v_min = VersionNumber("0.0.0")
    v_max = maximum(tbl) do tr
        v_elem = onlychild(tr.children[3])  # the third column is the version number
        isempty(v_elem) ? v_min : vparse(v_elem.text)
    end

    # We intentionally retain the 10.0. prefix and append the build number to the end
    # I have confirmed this prefix with versions listed on Defender for Endpoint
    return vparse(join((10, 0, v_max), "."))
end

_get_latest_version(::Windows10Singleton, ::WindowsOperatingSystem) =
    _get_latest_windows_10_version(WINDOWS_10_URI, "windows-10-release-history")
_get_latest_version(::Windows11Singleton, ::WindowsOperatingSystem) =
    _get_latest_windows_11_version(WINDOWS_11_URI, "windows-11-release-history")

function _get_latest_version(::MicrosoftWindowsSingleton, ::OperatingSystem)
    throw(ArgumentError("Microsoft Windows is not supported for any other operating system, as it is itself a Windows operating system"))
end
