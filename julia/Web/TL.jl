# Scrape Tom Lehrer's Content
# Authored June, 2023, by Jake Ireland

using HTTP, JSON, DataFrames, CSV, ProgressMeter

const BASE_URI = "https://tomlehrersongs.com/wp-json/wp/v2/posts/"
const BASE_URI_ALT = "https://tomlehrer.wpengine.com/"
const DEFAULT_DICT = Dict{String, Any}()

struct TLContent
    id::Int
end

function get_content(t::TLContent)
    r = HTTP.get(joinpath(BASE_URI, string(t.id)), status_exception = false)
    r.status >= 300 && return DEFAULT_DICT
    d = JSON.parse(String(r.body))
    status = get(get(d, "data", DEFAULT_DICT), "status", 0)
    status >= 300 && return DEFAULT_DICT
    return d
end
get_content(i::Int) = get_content(TLContent(i))

function get_content_alt(t::TLContent)
    query = ["p" => t.id]
    r =  HTTP.get(BASE_URI_ALT, query = query, status_exception = false)
    r.status >= 300 && return nothing
    return r
end
get_content_alt(i::Int) = get_content_alt(TLContent(i))

_get_rendered(d::Dict{String, Any}) = get(d, "rendered", missing)

get_title(d::Dict{String, Any}) = _get_rendered(get(d, "title", DEFAULT_DICT))
get_title(t::TLContent) = get_title(get_content(t))
get_title(i::Int) = get_title(TLContent(i))

get_url(d::Dict{String, Any}) = _get_rendered(get(d, "guid", DEFAULT_DICT))
get_url(t::TLContent) = get_url(get_content(t))
get_url(i::Int) = get_url(TLContent(i))

function write_row!(df::DataFrame, t::TLContent)
    d = get_content(t)
    isempty(d) && return df
    title = get_title(d)
    url = get_url(d)
    push!(df, (t.id, title, url))
    return df
end

function main()
    df = DataFrame(id = Int[], title = String[], url = String[])
    @showprogress for i in 1:1000
        t = TLContent(i)
        write_row!(df, t)
    end
    CSV.write("tl-out.csv", df)
end
