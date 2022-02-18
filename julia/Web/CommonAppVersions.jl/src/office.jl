# Office 2013
const OFFICE_2013_URI = "https://docs.microsoft.com/en-us/officeupdates/update-history-office-2013"

# Office 2016
const OFFICE_2016_RETAIL_URI = "https://docs.microsoft.com/en-gb/officeupdates/update-history-office-2019"
const OFFICE_2016_RETAIL_REGEX = r"Version (?:\d+) \(Build (\d+).(?:\d+)\)"
const OFFICE_2016_URI = "https://docs.microsoft.com/en-us/officeupdates/office-updates-msi"
# const OFFICE_365_GUID = "4b323baf-6213-40ab-81b2-aa37d83f7296"

# Office 365
const OFFICE_365_BUILD_URI = "https://docs.microsoft.com/en-us/officeupdates/update-history-microsoft365-apps-by-date/"
const OFFICE_365_NOGUID_URI = "https://support.microsoft.com/en-us/office/what-s-new-in-microsoft-365"
const OFFICE_365_GUID = "95c8d81d-08ba-42c1-914f-bca4603e1426"
const OFFICE_365_URI = OFFICE_365_NOGUID_URI * "-" * OFFICE_365_GUID

# Types/structs

abstract type MicrosoftOfficeSingleton <: CommonApplication end

struct Office2007Singleton <: MicrosoftOfficeSingleton end
const Office2007 = Office2007Singleton()

struct Office2010Singleton <: MicrosoftOfficeSingleton end
const Office2010 = Office2010Singleton()

struct Office2013Singleton <: MicrosoftOfficeSingleton end
const Office2013 = Office2013Singleton()

struct Office2016Singleton <: MicrosoftOfficeSingleton end
const Office2016 = Office2016Singleton()

struct Office365Singleton <: MicrosoftOfficeSingleton end
const Office365 = Office365Singleton()

# Version methods

get_latest_version(::Office2007Singleton) = VersionNumber("12.0.6612")  # EOL: 10 Oct., 2017

get_latest_version(::Office2010Singleton) = VersionNumber("14.0.7261")  # EOL: 13 Oct., 2020

function _get_latest_version(::Office2013Singleton, ::WindowsOperatingSystem)
    r = HTTP.get(OFFICE_2013_URI)
    doc = Gumbo.parsehtml(String(r.body))
    elem = _findfirst_html_tag(doc, "id", "center-doc-outline")
    v_str = elem.parent.children[5].children[2].children[2].children[1].text
    return VersionNumber(_reduce_version_major_minor_micro(v_str))
end

function _get_latest_retail_version(::Office2016Singleton, ::WindowsOperatingSystem)
    # Retail version - build major version is the micro version for Office 2016
    # Source: https://github.com/MicrosoftDocs/OfficeDocs-OfficeUpdates/issues/49#issuecomment-423573620
    r = HTTP.get(OFFICE_2016_RETAIL_URI)
    doc = Gumbo.parsehtml(String(r.body))
    elem = _findfirst_html_tag(doc, "id", "retail-versions-of-office-2016-c2r-and-office-2019")
    versions = elem.parent.children[18].children[2].children
    unmatched_build_str = versions[1].children[2].children[1].text
    m = match(OFFICE_2016_RETAIL_REGEX, unmatched_build_str)
    build_str = only(m.captures)
    return VersionNumber(_reduce_version_major_minor_micro("16.0." * build_str))
    # NO!  This will return the _retail_ stable release.  Should be 16.0.5266 at time of writing
end

function _get_latest_version(::Office2016Singleton, ::WindowsOperatingSystem)
    # MSI version
    error("not implemented")
    
    # MSI - not fully figured out: 
    # 1. Get page `https://docs.microsoft.com/en-gb/officeupdates/office-updates-msi`
    #    Find headers of `Office 2016 updates` and `Office 2013 updates`, and follow the respective links in the `Latest Public Update (PU)` column;
    # 2. This link will be the latest Knowledge Base (KB) version, e.g., `https://support.microsoft.com/en-gb/topic/february-2022-updates-for-microsoft-office-4b323baf-6213-40ab-81b2-aa37d83f7296`. 
    #    From this page, find the correct product section, e.g., `Microsoft Office 2016` under `List of office updates released in February 2022`.
    # 3. Iterate over table of updated components (for x64) and find the largest number.
end

function _get_latest_build_version(::Office365Singleton, ::WindowsOperatingSystem)
    r = HTTP.get(OFFICE_365_BUILD_URI)
    doc = Gumbo.parsehtml(String(r.body))
    elem = _findfirst_html_tag(doc, "id", "supported-versions")
    v_str = elem.parent.children[8].children[2].children[1].children[3].children[1].text
    return VersionNumber(_reduce_version_major_minor_micro(v_str))
end

function _get_latest_version(O365::Office365Singleton, ::WindowsOperatingSystem)
    r = HTTP.get(OFFICE_365_URI)
    doc = Gumbo.parsehtml(String(r.body))
    elem = _findfirst_html_tag(doc, "id", "Platform-supTabControlContent-1")
    v_str = elem.children[1].children[2].children[1].text
    #=
    ## verify the build version
    build_version = _get_latest_build_version(O365)
    i = findlast('.', v_str)
    j = findprev('.', v_str, prevind(v_str, i))
    build_v_str = SubString(v_str, nextind(v_str, j))
    @assert(string(build_version) == build_v_str)
    ## NOTE: these are not actually the same always, so no point in validating
    ## e.g., build_version = 14827.20198, but build_v_str = 14729.20260
    =#
    return VersionNumber(_reduce_version_major_minor_micro(v_str))
end

