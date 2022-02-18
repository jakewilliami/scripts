const OFFICE_365_BUILD_URI = "https://docs.microsoft.com/en-us/officeupdates/update-history-microsoft365-apps-by-date/"
const OFFICE_365_NOGUID_URI = "https://support.microsoft.com/en-us/office/what-s-new-in-microsoft-365"
const OFFICE_365_GUID = "95c8d81d-08ba-42c1-914f-bca4603e1426"
const OFFICE_365_URI = OFFICE_365_NOGUID_URI * "-" * OFFICE_365_GUID

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


function get_latest_version(::Office2007Singleton)
    error("not implemented")
end

function get_latest_version(::Office2010Singleton)
    error("not implemented")
end

function get_latest_version(::Office2013Singleton)
    error("not implemented")
end

function get_latest_version(::Office2016Singleton)
    error("not implemented")
end

function _get_latest_build_version(::Office365Singleton)
    r = HTTP.get(OFFICE_365_BUILD_URI)
    doc = parsehtml(String(r.body))
    v_str = doc.root.children[2].children[2].children[1].children[2].children[1].children[1].children[1].children[3].children[8].children[2].children[1].children[3].children[1].text
    return VersionNumber(_reduce_version_major_minor_micro(v_str))
end

function get_latest_version(O365::Office365Singleton)
    r = HTTP.get(OFFICE_365_URI)
    doc = parsehtml(String(r.body))
    table_elem = nothing
    ## find the first element whose ID is the outer ID of the table
    for elem in PreOrderDFS(doc.root)
        if elem isa HTMLElement && getattr(elem, "id", "") == "Platform-supTabControlContent-1"
            table_elem = elem
            break
        end
    end
    ## get the version string from the table
    v_str = table_elem.children[1].children[2].children[1].text
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

