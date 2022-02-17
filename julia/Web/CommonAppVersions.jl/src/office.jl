const OFFICE_URI = ""

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


function get_latest_version(::MicrosoftOfficeSingleton)
    error("not implemented")
    # r = HTTP.get(OFFICE_URI)
    # doc = parsehtml(String(r.body))
    # return VersionNumber(_reduce_version_major_minor_micro(v_str))
end
