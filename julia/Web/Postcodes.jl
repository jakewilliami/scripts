using JSON, Base64

const tools0 = "dG9vbHMubnpwb3N0LmNvLm56"
const tools1 = "aHR0cHM6Ly90b29scy5uenBvc3QuY28ubnovbGVnYWN5L2FwaS9zdWdnZXN0X3BhcnRpYWw="
const tools2 = "aHR0cHM6Ly90b29scy5uenBvc3QuY28ubnovbGVnYWN5L2FwaS9wYXJ0aWFsX2RldGFpbHM="
const base0 = "aHR0cHM6Ly93d3cubnpwb3N0LmNvLm56"
const base1 = "aHR0cHM6Ly93d3cubnpwb3N0LmNvLm56L3Rvb2xzL2FkZHJlc3MtcG9zdGNvZGUtZmluZGVy"

intoURL(base64str::AbstractString) = String(Base64.base64decode(base64str))

function get_id(postcode::S) where {S <: AbstractString}
    URL = "$(intoURL(tools1))?q=$(postcode)&MaxData=max%3A10"
	cmd = Cmd(`curl -i -s -k -X "GET"
		-H "Host: $(intoURL(tools0))"
		-H "Sec-Ch-Ua: \" Not A;Brand\";v=\"99\", \"Chromium\";v=\"90\""
		-H "Accept: application/json"
		-H "Sec-Ch-Ua-Mobile: ?0"
		-H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36"
		-H "Origin: $(intoURL(base0))"
		-H "Sec-Fetch-Site: same-site"
		-H "Sec-Fetch-Mode: cors"
		-H "Sec-Fetch-Dest: empty"
		-H "Referer: $(intoURL(base1))"
		-H "Accept-Language: en-GB,en-US;q=0.9,en;q=0.8"
		-H "Connection: close"
	    "$URL"`)
	command_out = split(read(cmd, String), "\n")
    j = JSON.parse(command_out[end])
	return j["addresses"][1]["UniqueId"]
end
get_id(postcode::Integer) = get_id(lpad(postcode, 4, "0"))

function get_location_info(ID::S) where {S <: Union{AbstractString, Integer}}
    URL = "$(intoURL(tools2))?unique_id=$(ID)"
	cmd = Cmd(`curl -i -s -k -X "GET"
	    -H "Host: $(intoURL(tools0))"
		-H "Sec-Ch-Ua: \" Not A;Brand\";v=\"99\", \"Chromium\";v=\"90\""
		-H "Accept: application/json"
		-H "Sec-Ch-Ua-Mobile: ?0"
		-H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36"
		-H "Origin: $(intoURL(base0))"
		-H "Sec-Fetch-Site: same-site"
		-H "Sec-Fetch-Mode: cors"
		-H "Sec-Fetch-Dest: empty"
		-H "Referer: $(intoURL(base1))"
		-H "Accept-Language: en-GB,en-US;q=0.9,en;q=0.8"
		-H "Connection: close"
		"$URL"`)
	command_out = split(read(cmd, String), "\n")
	j = JSON.parse(command_out[end])
    return j["details"][1]["CityTown"]
end

println(get_location_info(get_id(6021)))
