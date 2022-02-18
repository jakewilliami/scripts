const OFFICE_365_URI = "https://docs.microsoft.com/en-us/officeupdates/update-history-microsoft365-apps-by-date/"

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

function get_latest_version(::Office365Singleton)
    r = HTTP.get(OFFICE_365_URI)
    doc = parsehtml(String(r.body))
    v_str = doc.root.children[2].children[2].children[1].children[2].children[1].children[1].children[1].children[3].children[8].children[2].children[1].children[3].children[1].text
    return VersionNumber(_reduce_version_major_minor_micro(v_str))
end
