module PCall

using JSON, HTTP, Base64, Libz#, TranscodingStreams, CodecZlib

export suggest_locations,
	get_suggested_postcodes,
	get_suggested_addresses,
	get_postcode_details,
	get_address_details

# Encoded constants

const tools0 = "dG9vbHMubnpwb3N0LmNvLm56"
const tools1 = "aHR0cHM6Ly90b29scy5uenBvc3QuY28ubnovbGVnYWN5L2FwaS9zdWdnZXN0X3BhcnRpYWw="
const tools2 = "aHR0cHM6Ly90b29scy5uenBvc3QuY28ubnovbGVnYWN5L2FwaS9wYXJ0aWFsX2RldGFpbHM="
const base0 = "aHR0cHM6Ly93d3cubnpwb3N0LmNvLm56"
const base1 = "aHR0cHM6Ly93d3cubnpwb3N0LmNvLm56L3Rvb2xzL2FkZHJlc3MtcG9zdGNvZGUtZmluZGVy"

intoURI(base64str::S) where {S <: AbstractString} =
	String(Base64.base64decode(base64str))

### Helper functions

error_if_unsuccessful(j::D) where {D <: Dict} =
	(j["success"] || error(j["error"]["message"] * "; error code " * string(j["error"]["code"])))

### Main request function

const GLOB_BASE_ENCODED = "aHR0cHM6Ly93d3cu"
const BASE_PUBLIC_URI_ENCODED = "bnpwb3N0LmNvLm56"
# const PUBLIC_URI_ENCODED = "aHR0cHM6Ly93d3cubnpwb3N0LmNvLm56L3Rvb2xzL2FkZHJlc3MtcG9zdGNvZGUtZmluZGVy"
const PUBLIC_URI_ENCODED = "L3Rvb2xzL2FkZHJlc3MtcG9zdGNvZGUtZmluZGVy"
const BASE_API_URI_ENCODED = "dG9vbHMubnpwb3N0LmNvLm56"
const API_URI_ENCODED = "aHR0cHM6Ly90b29scy5uenBvc3QuY28ubnovbGVnYWN5L2FwaS8="

const LOCATOR_SUFFIX_ENCODED = "Jk1heERhdGE9bWF4JTNBMTA="
const UID_QUERY_ENCODED = "L3N1Z2dlc3RfcGFydGlhbD9xPQ=="
const DPID_QUERY_ENCODED = "L3N1Z2dlc3Q/cT0="
const PC_QUERY_ENCODED = "L3BhcnRpYWxfZGV0YWlscz91bmlxdWVfaWQ9"
const ADDR_QUERY_ENCODED = "L2RldGFpbHM/ZHBpZD0="

const COORD_KEY_ENCODED = "TlpHRDJrQ29vcmQ="
const UID_KEY_ENCODED = "VW5pcXVlSWQ="
const PC_KEY_ENCODED = "RnVsbFBhcnRpYWw="
const REGION_KEY_ENCODED = "Q2l0eVRvd24="

const GLOB_BASE = intoURI(GLOB_BASE_ENCODED)
const BASE_PUBLIC_URI = intoURI(BASE_PUBLIC_URI_ENCODED)
const PUBLIC_URI = GLOB_BASE * intoURI(BASE_PUBLIC_URI_ENCODED) * intoURI(PUBLIC_URI_ENCODED)
const BASE_API_URI = intoURI(BASE_API_URI_ENCODED)
const API_URI = intoURI(API_URI_ENCODED)

const LOCATOR_SUFFIX = intoURI(LOCATOR_SUFFIX_ENCODED)
const UID_QUERY = intoURI(UID_QUERY_ENCODED)
const DPID_QUERY = intoURI(DPID_QUERY_ENCODED)
const PC_QUERY = intoURI(PC_QUERY_ENCODED)
const ADDR_QUERY = intoURI(ADDR_QUERY_ENCODED)

const COORD_KEY = intoURI(COORD_KEY_ENCODED)
const UID_KEY = intoURI(UID_KEY_ENCODED)
const PC_KEY = intoURI(PC_KEY_ENCODED)
const REGION_KEY = intoURI(REGION_KEY_ENCODED)

"""
Main request function.
"""
function pcall(URL::S) where {S <: AbstractString}
	r = HTTP.request("GET", URL,
		[
			"Host" => "$BASE_API_URI",
			"Sec-Ch-Ua" => "\" Not A;Brand\";v=\"99\", \"Chromium\";v=\"90\"",
			"Accept" => "application/json",
			"Sec-Ch-Ua-Mobile" => "?0",
			"User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36",
			"Origin" => "$GLOB_BASE$BASE_PUBLIC_URI",
            "Accept-Encoding" => "gzip, deflate",
			"Sec-Fetch-Site" => "same-site",
			"Sec-Fetch-Mode" => "cors",
			"Sec-Fetch-Dest" => "empty",
			"Referer" => "$PUBLIC_URI",
			"Accept-Language" => "en-GB,en-US;q=0.9,en;q=0.8",
			"Connection" => "close"
		])
	
	return r
end

function pcall(URL::S, responsekey::S) where {S <: AbstractString}
	r = pcall(URL)
    # j = JSON.parse(String(r.body))
    # j = JSON.parse(String(transcode(GzipDecompressor, r.body)))
    j = JSON.parse(String(read(ZlibInflateInputStream(r.body))))
	error_if_unsuccessful(j)
	
	return j[responsekey]
end

function pcall(baseURL::S, identifier::T, responsekey::S) where
		{S <: AbstractString, T <: Union{AbstractString, Integer}}
	
	identifier = HTTP.escapeuri(identifier)
	URL = string(baseURL, identifier)
	
	return pcall(URL, responsekey)
end

function pcall(baseURL::S, identifier::T, suffixURL::S, responsekey::S) where
		{S <: AbstractString, T <: Union{AbstractString, Integer}}
	
	identifier = HTTP.escapeuri(identifier)
	URL = string(baseURL, identifier, suffixURL)
	
	return pcall(URL, responsekey)
end

### Locator methods

"""
```julia
get_suggested_postcodes(postcode) -> Vector{Dict{String, Any}}
```
Sends a request to get matching postcodes based on your input query.  Each returned dictionary contains the keys `"UniqueID"` and `"FullPartial"`.  `UniqueID` is used by `get_postcode_details`.
"""
function get_suggested_postcodes(postcode::T) where {T <: Union{AbstractString, Integer}}
	baseURL = "$API_URI$UID_QUERY"
	responsekey = "addresses"
	
	return pcall(baseURL, postcode, LOCATOR_SUFFIX, responsekey)
end

"""
```julia
get_suggested_addresses(addr) -> Vector{Dict{String, Any}}
```
Sends a request to get matching addresses based on your input query.  Each returned dictionary contains the keys `"SourceDesc"`, `"FullAddress"`, and `"DPID"`.  `DPID` is used by `get_address_details`.
"""
function get_suggested_addresses(addr::T) where {T <: Union{AbstractString, Integer}}
	baseURL = "$API_URI$DPID_QUERY"
	responsekey = "addresses"
	
	return pcall(baseURL, addr, LOCATOR_SUFFIX, responsekey)
end

"""
```julia
suggest_locations(query) -> Vector{Dict{String, Any}}
```
Sends a request to get matching postcodes and addresses based on your input query.  This is similar to NZP's address/postcode finder, but see `PCall.nzp_search` for a more specific replication of the website.
"""
function suggest_locations(query::T) where {T <: Union{AbstractString, Integer}}
	possible_postcodes = get_suggested_postcodes(query)
	possible_addresses = get_suggested_addresses(query)
	return vcat(possible_postcodes, possible_addresses)
end

### Details methods

function get_postcode_details(uniqueID::T) where {T <: Union{AbstractString, Integer}}
	baseURL = "$API_URI$PC_QUERY"
	responsekey = "details"
	
	return pcall(baseURL, uniqueID, responsekey)
end

function get_address_details(DPID::T) where {T <: Union{AbstractString, Integer}}
	baseURL = "$API_URI$ADDR_QUERY"
	responsekey = "details"
	
	return pcall(baseURL, DPID, responsekey)
end

### Nothing/Missing methods

for f in (:suggest_locations, :get_suggested_postcodes, :get_suggested_addresses, :get_postcode_details, :get_address_details)
	@eval $f(::Nothing) = nothing
	@eval $f(::Missing) = missing
end

### Private methods that probably don't need exposing

function get_region_from_postcode(postcode::S) where {S <: AbstractString}
	possible_postcodes = get_suggested_postcodes(postcode)
	
	# isempty(possible_postcodes) && error("No postcodes found matching $postcode")
	isempty(possible_postcodes) && return nothing
	
	best_suggested = possible_postcodes[1]
	uniqueID = best_suggested[UID_KEY]
	full_partial = best_suggested[PC_KEY]
	
	# full_partial ≠ postcode &&
	# 	error("Cannot find postcode $postcode; closest match is $full_partial")
	full_partial ≠ postcode && return nothing
	
	region = get_postcode_details(uniqueID)[1][REGION_KEY]
	
	return region
end
get_region_from_postcode(postcode::N) where {N <: Integer} =
	get_region_from_postcode(lpad(postcode, 4, "0"))

function get_postcode_from_addr(addr::S) where {S <: AbstractString}
	possible_addresses = get_suggested_addresses(addr)
	
	# isempty(possible_addresses) && error("No addresses found matching $addr")
	isempty(possible_addresses) && return nothing
	
	best_suggested = possible_addresses[1]
	DPID = best_suggested["DPID"]
	
	postcode = get_address_details(DPID)[1]["Postcode"]
	
	return postcode
end

function get_coordinates_from_addr(addr::S) where {S <: AbstractString}
	possible_addresses = get_suggested_addresses(addr)
	
	# isempty(possible_addresses) && error("No addresses found matching $addr")
	isempty(possible_addresses) && return nothing
	
	best_suggested = possible_addresses[1]
	DPID = best_suggested["DPID"]
	
	coordinates = get_address_details(DPID)[1][COORD_KEY]["coordinates"]
	
	return (coordinates[2], coordinates[1])
end

function nzp_search(query::S) where {S <: AbstractString}
    possible_postcodes = get_suggested_postcodes(query)
    possible_addresses = get_suggested_addresses(query)

    results = Pair{Any, Any}[]
    for p in possible_postcodes
        push!(results, nothing => p["FullPartial"])
    end
    for a in possible_addresses
        push!(results, a["FullAddress"] => get_address_details(a["DPID"])[1]["Postcode"])
    end

    return results
end

end # end module

# using .PCall

# println(PCall.suggest_locations(704))
# println(PCall.get_region_from_postcode(6021))
# println(PCall.get_region_from_postcode(0666)) # invalid postcode
# println(PCall.get_postcode_from_addr("21 St Michaels Cres"))
# println(PCall.get_coordinates_from_addr("21 St Michaels Cres"))

using .PCall, Test

p1 = PCall.suggest_locations(704)
# p1_out = Any[Dict{String, Any}("UniqueId" => 3001387, "FullPartial" => "7045"), Dict{String, Any}("UniqueId" => 3001388, "FullPartial" => "7047"), Dict{String, Any}("UniqueId" => 3001389, "FullPartial" => "7043"), Dict{String, Any}("SourceDesc" => "Postal\\Physical", "FullAddress" => "704 Dominion Road, Mount Eden, Auckland 1041", "DPID" => 1546480), Dict{String, Any}("SourceDesc" => "Postal\\Physical", "FullAddress" => "704 East Coast Road, Pinehill, Auckland 0632", "DPID" => 1327087), Dict{String, Any}("SourceDesc" => "Postal\\Physical", "FullAddress" => "704 Great North Road, Grey Lynn, Auckland 1021", "DPID" => 80244), Dict{String, Any}("SourceDesc" => "Postal\\Physical", "FullAddress" => "704 Huia Road, Parau, Auckland 0604", "DPID" => 2565175), Dict{String, Any}("SourceDesc" => "Postal\\Physical", "FullAddress" => "704 Mount Eden Road, Mount Eden, Auckland 1024", "DPID" => 355007), Dict{String, Any}("SourceDesc" => "Postal\\Physical", "FullAddress" => "704 New North Road, Mount Albert, Auckland 1022", "DPID" => 81197), Dict{String, Any}("SourceDesc" => "Postal\\Physical", "FullAddress" => "704 Remuera Road, Remuera, Auckland 1050", "DPID" => 1357548), Dict{String, Any}("SourceDesc" => "Postal\\Physical", "FullAddress" => "704 Sandringham Road Extension, Wesley, Auckland 1041", "DPID" => 2614828), Dict{String, Any}("SourceDesc" => "Postal\\Physical", "FullAddress" => "704 South Titirangi Road, Titirangi, Auckland 0604", "DPID" => 565340), Dict{String, Any}("SourceDesc" => "Postal\\Physical", "FullAddress" => "704 Swanson Road, Swanson, Auckland 0612", "DPID" => 1043026)]
p1_out = Any[Dict{String, Any}("UniqueId" => 3001386, "FullPartial" => "7045"), Dict{String, Any}("UniqueId" => 3001387, "FullPartial" => "7047"), Dict{String, Any}("UniqueId" => 3001388, "FullPartial" => "7043"), Dict{String, Any}("SourceDesc" => "Postal\\Physical", "FullAddress" => "704 Dominion Road, Mount Eden, Auckland 1041", "DPID" => 1546480), Dict{String, Any}("SourceDesc" => "Postal\\Physical", "FullAddress" => "704 East Coast Road, Pinehill, Auckland 0632", "DPID" => 1327087), Dict{String, Any}("SourceDesc" => "Postal\\Physical", "FullAddress" => "704 Great North Road, Grey Lynn, Auckland 1021", "DPID" => 80244), Dict{String, Any}("SourceDesc" => "Postal\\Physical", "FullAddress" => "704 Huia Road, Parau, Auckland 0604", "DPID" => 2565175), Dict{String, Any}("SourceDesc" => "Postal\\Physical", "FullAddress" => "704 Mount Eden Road, Mount Eden, Auckland 1024", "DPID" => 355007), Dict{String, Any}("SourceDesc" => "Postal\\Physical", "FullAddress" => "704 New North Road, Mount Albert, Auckland 1022", "DPID" => 81197), Dict{String, Any}("SourceDesc" => "Postal\\Physical", "FullAddress" => "704 Remuera Road, Remuera, Auckland 1050", "DPID" => 1357548), Dict{String, Any}("SourceDesc" => "Postal\\Physical", "FullAddress" => "704 Sandringham Road Extension, Wesley, Auckland 1041", "DPID" => 2614828), Dict{String, Any}("SourceDesc" => "Postal\\Physical", "FullAddress" => "704 South Titirangi Road, Titirangi, Auckland 0604", "DPID" => 565340), Dict{String, Any}("SourceDesc" => "Postal\\Physical", "FullAddress" => "704 Swanson Road, Swanson, Auckland 0612", "DPID" => 1043026)]
p2 = PCall.get_region_from_postcode(6021)
p2_out = "Wellington"
p3 = PCall.get_region_from_postcode(0666) # invalid postcode should return nothing
p3_out = nothing
p4 = PCall.get_postcode_from_addr("21 St Michaels Cres")
p4_out = "6012"
p5 = PCall.get_coordinates_from_addr("21 St Michaels Cres")
# (latitude, longitude)
p5_out = (-41.289891, 174.762686)

@testset "PCall" begin
    for i in 1:5
        pi = Symbol("p$(i)")
        pi_out = Symbol("p$(i)_out")
        println(i)
        @test @eval $pi == $pi_out
    end
end
